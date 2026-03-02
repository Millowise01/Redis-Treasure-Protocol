# Quick Reference Card - Copy & Paste Commands

## Setup
```bash
cd c:\Redis-Treasure-Protocol\redis-treasure-docker
docker-compose up --build
```

## Step 0: Verify
```bash
docker ps
curl http://localhost:7000/clue/1
```

## Step 1: Rate Limit (run 6x)
```bash
curl http://localhost:7000/clue/1
```

## Step 2: Get Redis Container ID
```bash
docker ps | findstr redis
```

## Step 2: Connect to Redis
```bash
docker exec -it <CONTAINER_ID> redis-cli
```

## Step 2: Inside redis-cli
```redis
SETEX temp_key 10 unlock
```

## Step 2: Immediately in another terminal
```bash
curl http://localhost:7000/clue/2
```

## Step 3: Inside redis-cli
```redis
PUBLISH treasure_channel unlock
GET golden_key
```

## Step 4: Claim Treasure (run 2x)
```bash
curl http://localhost:7000/treasure
```

## Timestamp (for screenshots)
```bash
echo %date% %time%
```

## Cleanup
```bash
docker-compose down
```

---

## Expected Outputs

### Step 1 (6th request):
```json
{
  "concept": "Rate Limiting",
  "message": "Redis tracked your requests using INCR and EXPIRE...",
  "nextClue": "Create a Redis key 'temp_key'..."
}
```

### Step 2 (success):
```json
{
  "source": "MongoDB",
  "message": "Redis is great at broadcasting. Use the command 'PUBLISH treasure_channel unlock'..."
}
```

### Step 3 (PUBLISH result):
```
(integer) 1
```

### Step 3 (GET golden_key):
```
"unlocked"
```

### Step 4 (treasure):
```json
{
  "message": "Congratulations! You mastered Rate Limiting, TTL, Caching, and Pub/Sub.",
  "treasure": "FLAG{redis_king_2026}"
}
```
