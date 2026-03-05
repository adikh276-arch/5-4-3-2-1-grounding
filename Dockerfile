FROM node:20-alpine AS builder

WORKDIR /app

COPY package*.json ./
RUN npm ci

COPY . .

RUN npm run build


FROM nginx:alpine

WORKDIR /usr/share/nginx/html

# Copy the built files to the subpath directory
COPY --from=builder /app/dist /usr/share/nginx/html/5-4-3-2-1-grounding

# Ensure Nginx can read the files
RUN chmod -R 755 /usr/share/nginx/html/5-4-3-2-1-grounding

# Configure Nginx for subpath hosting and correct MIME types
RUN rm /etc/nginx/conf.d/default.conf
COPY vite-nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
