# Use a multi-stage build
FROM --platform=linux/amd64 node:16 AS build

WORKDIR /app

COPY package*.json ./

RUN npm install

COPY . .

RUN npm run build

# Use the same Node.js image for the final stage
FROM --platform=linux/amd64 node:16

WORKDIR /app

COPY --from=build /app/dist ./dist
COPY --from=build /app/package*.json ./

RUN npm install --only=production

# Expose the port your app runs on
EXPOSE 3001

# Command to run your app (update to main.js)
CMD ["node", "dist/main.js"]
