# SiteWork API. Build from backend/:
#   docker build -t sitework-api .                    # the API
#   docker build -t sitework-migrate --target migrate .  # applies migrations, then exits
# Run the migrate image once per release before starting the new API.
# Configuration comes only from the environment (see .env.example); no secrets are baked in.

FROM node:24-bookworm-slim AS build
WORKDIR /app
# `prisma generate` runs on install and reads prisma.config.ts, which needs a
# database URL to exist. Nothing connects to it during the build.
ENV DATABASE_URL=postgresql://build:build@localhost:5432/build
COPY package.json package-lock.json prisma.config.ts ./
COPY prisma ./prisma
RUN npm ci
COPY tsconfig*.json nest-cli.json ./
COPY src ./src
RUN npm run build

# Applies pending migrations (needs the Prisma CLI, a dev dependency).
FROM build AS migrate
ENV DATABASE_URL=
CMD ["npx", "prisma", "migrate", "deploy"]

FROM build AS prune
RUN npm prune --omit=dev

FROM node:24-bookworm-slim AS api
ENV NODE_ENV=production
WORKDIR /app
COPY --from=prune --chown=node:node /app/package.json ./
COPY --from=prune --chown=node:node /app/node_modules ./node_modules
COPY --from=prune --chown=node:node /app/dist ./dist
USER node
EXPOSE 3000
HEALTHCHECK --interval=30s --timeout=5s --start-period=20s \
  CMD node -e "fetch('http://127.0.0.1:' + (process.env.PORT || 3000) + '/api/v1/health').then((r) => process.exit(r.ok ? 0 : 1), () => process.exit(1))"
CMD ["node", "dist/main.js"]
