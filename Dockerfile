# Stage 1: Встановлення залежностей та збирання проєкту (Builder)
FROM node:20-alpine AS builder
WORKDIR /app
COPY package.json package-lock.json* ./
RUN npm ci
COPY . .
RUN npm run build

# Stage 2: Фінальний легкий образ для запуску (Runner)
FROM nginx:alpine AS runner
# Копіюємо лише готові зібрані файли з першого етапу
COPY --from=builder /app/dist /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]