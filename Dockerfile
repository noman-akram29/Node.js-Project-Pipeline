
FROM node:20-alpine AS builder

WORKDIR /app

COPY package*.json ./

RUN npm ci

COPY . .

RUN npm run build

FROM node:20-alpine AS production

RUN addgroup -g 1001 -S nodejs
RUN adduser -S nextjs -u 1001

WORKDIR /app

COPY --from=builder /app/package*.json ./
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/public ./public
COPY --from=builder /app/.next ./.next
COPY --from=builder /app/next.config.js ./   
COPY --from=builder /app/next-env.d.ts ./      

RUN npm pkg set \
    overrides.ejs="^3.1.10" \
    overrides.minimist="^1.2.8" \
    overrides.loader-utils="^3.3.0" \
    overrides.immer="^10.1.1" \
    overrides.url-parse="^1.5.10" \
    overrides.qs="^6.13.0" \
    overrides.tar="^6.2.1" \
    overrides.semver="^7.6.3" \
    overrides.braces="^3.0.3" \
    overrides.ansi-regex="^6.1.0"

RUN rm -rf node_modules && npm ci --only=production

RUN chown -R nextjs:nodejs /app
USER nextjs

EXPOSE 3000

CMD ["npm", "start"]