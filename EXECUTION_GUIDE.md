# Redis Treasure Protocol - Execution Guide

## Step 0: Ignite the Infrastructure

### Terminal 1 - Start Docker Services
```bash
cd c:\Redis-Treasure-Protocol\redis-treasure-docker
docker-compose up --build
```

### Terminal 2 - Verify Services
```bash
# Check running containers
docker ps

# Test API connection
curl http://localhost:7000/clue/1
```

**📸 SCREENSHOT #1: Show docker ps output and first curl response**

---

## Step 1: Break the Gatekeeper (Rate Limiting)

Run this command 6+ times rapidly:
```bash
curl http://localhost:7000/clue/1
curl http://localhost:7000/clue/1
curl http://localhost:7000/clue/1
curl http://localhost:7000/clue/1
curl http://localhost:7000/clue/1
curl http://localhost:7000/clue/1
```

Expected: After 5 requests, you'll get a 429 error with the next clue.

**📸 SCREENSHOT #2: Show the 429 error response with rate limiting message**

---

## Step 2: The Race Against Time (TTL)

### Connect to Redis CLI
```bash
# First, get Redis container ID
docker ps

# Connect to Redis (replace <redis_container_id> with actual ID)
docker exec -it <redis_container_id> redis-cli
```

### Inside redis-cli, create the temporary key
```redis
SETEX temp_key 10 unlock
```

### IMMEDIATELY (within 10 seconds) run in another terminal:
```bash
curl http://localhost:7000/clue/2
```

**📸 SCREENSHOT #3: Show redis-cli with SETEX command and curl response (with timestamp)**

---

## Step 3: The Ghost Signal (Pub/Sub)

### Inside redis-cli (still connected):
```redis
PUBLISH treasure_channel unlock
```

### Check server logs in Terminal 1
You should see: "Event-Driven Architecture: Pub/Sub triggered the unlock!"

**📸 SCREENSHOT #4: Show PUBLISH command and server logs with unlock message**

---

## Step 4: Claim the Treasure

### First request (from MongoDB):
```bash
curl http://localhost:7000/treasure
```

### Second request (from Redis Cache):
```bash
curl http://localhost:7000/treasure
```

Notice the "source" field changes from MongoDB to Redis Cache.

**📸 SCREENSHOT #5: Show both curl responses demonstrating caching**

---

## Quick Command Reference

### Get Redis Container ID:
```bash
docker ps | findstr redis
```

### Connect to Redis:
```bash
docker exec -it <redis_container_id> redis-cli
```

### Verify Redis Keys:
```redis
KEYS *
GET golden_key
TTL temp_key
```

---

## Expected Final Flag
`FLAG{redis_king_2026}`

## Concepts Demonstrated
✅ Rate Limiting (INCR + EXPIRE)
✅ Time-To-Live (SETEX)
✅ Pub/Sub (PUBLISH/SUBSCRIBE)
✅ Read-Through Caching (GET/SETEX)
✅ Event-Driven Architecture
