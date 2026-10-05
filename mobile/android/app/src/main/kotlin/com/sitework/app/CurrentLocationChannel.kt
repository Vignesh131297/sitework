package com.sitework.app

import android.annotation.SuppressLint
import android.content.Context
import android.location.Location
import android.location.LocationListener
import android.location.LocationManager
import android.os.Build
import android.os.CancellationSignal
import android.os.Handler
import android.os.Looper
import com.google.android.gms.common.ConnectionResult
import com.google.android.gms.common.GoogleApiAvailability
import com.google.android.gms.location.CurrentLocationRequest
import com.google.android.gms.location.LocationServices
import com.google.android.gms.location.Priority
import com.google.android.gms.tasks.CancellationTokenSource
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodChannel

/**
 * One position fix for check-ins and photo updates.
 *
 * geolocator's position requests also start GNSS NMEA and satellite-status
 * listeners, which this app never uses. Removing them is a blocking call into
 * the location service, and some Android builds deadlock there, freezing the
 * app (an ANR). This asks for a single position and nothing else.
 *
 * Permission is requested through geolocator before Dart calls this.
 */
class CurrentLocationChannel(private val context: Context) {
    fun register(messenger: BinaryMessenger) {
        MethodChannel(messenger, "com.sitework.app/location").setMethodCallHandler { call, result ->
            when (call.method) {
                "currentPosition" -> currentPosition(call.argument<Int>("timeoutMs") ?: 10_000, Reply(result))
                else -> result.notImplemented()
            }
        }
    }

    @SuppressLint("MissingPermission")
    private fun currentPosition(timeoutMs: Int, reply: Reply) {
        val playServices = GoogleApiAvailability.getInstance().isGooglePlayServicesAvailable(context)
        if (playServices != ConnectionResult.SUCCESS) {
            fromLocationManager(timeoutMs, reply)
            return
        }
        val request = CurrentLocationRequest.Builder()
            .setPriority(Priority.PRIORITY_HIGH_ACCURACY)
            .setDurationMillis(timeoutMs.toLong())
            // A fix from the last half minute is as good as a new one.
            .setMaxUpdateAgeMillis(30_000)
            .build()
        LocationServices.getFusedLocationProviderClient(context)
            .getCurrentLocation(request, CancellationTokenSource().token)
            .addOnSuccessListener { location -> reply.send(location) }
            .addOnFailureListener { reply.send(null) }
    }

    /** Phones without Google Play services: ask the platform directly. */
    @SuppressLint("MissingPermission")
    private fun fromLocationManager(timeoutMs: Int, reply: Reply) {
        val manager = context.getSystemService(Context.LOCATION_SERVICE) as LocationManager
        val provider = listOf(LocationManager.GPS_PROVIDER, LocationManager.NETWORK_PROVIDER)
            .firstOrNull { manager.isProviderEnabled(it) }
        if (provider == null) {
            reply.send(null)
            return
        }
        val handler = Handler(Looper.getMainLooper())
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.R) {
            val cancel = CancellationSignal()
            manager.getCurrentLocation(provider, cancel, context.mainExecutor) { location -> reply.send(location) }
            handler.postDelayed({
                cancel.cancel()
                reply.send(null)
            }, timeoutMs.toLong())
        } else {
            val listener = object : LocationListener {
                override fun onLocationChanged(location: Location) {
                    manager.removeUpdates(this)
                    reply.send(location)
                }

                @Deprecated("Required on API < 29")
                override fun onStatusChanged(provider: String?, status: Int, extras: android.os.Bundle?) {}

                override fun onProviderEnabled(provider: String) {}

                override fun onProviderDisabled(provider: String) {}
            }
            @Suppress("DEPRECATION")
            manager.requestSingleUpdate(provider, listener, Looper.getMainLooper())
            handler.postDelayed({
                manager.removeUpdates(listener)
                reply.send(null)
            }, timeoutMs.toLong())
        }
    }

    /** Answers Dart exactly once (a fix and a timeout can race). */
    private class Reply(private val result: MethodChannel.Result) {
        private var sent = false

        fun send(location: Location?) {
            if (sent) return
            sent = true
            result.success(
                location?.let {
                    mapOf(
                        "latitude" to it.latitude,
                        "longitude" to it.longitude,
                        "accuracyM" to it.accuracy.toDouble(),
                        "isMocked" to isMock(it),
                    )
                },
            )
        }

        private fun isMock(location: Location): Boolean =
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
                location.isMock
            } else {
                @Suppress("DEPRECATION")
                location.isFromMockProvider
            }
    }
}
