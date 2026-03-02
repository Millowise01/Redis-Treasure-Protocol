# Redis Treasure Protocol - Complete Execution Checklist

## ✅ Pre-Flight Checklist
- [ ] Docker Desktop is running
- [ ] Terminal is open in `c:\Redis-Treasure-Protocol\redis-treasure-docker`
- [ ] Screenshot tool is ready
- [ ] Timestamp visible in terminal (use `echo %date% %time%` on Windows)

---

## 📋 STEP 0: Infrastructure Setup

### Terminal 1 (Server Logs)
```bash
cd c:\Redis-Treasure-Protocol\redis-treasure-docker
docker-compose up --build
```

Wait for: "Treasure Hunt Server running at http://localhost:7000"

### Terminal 2 (Commands)
```bash
# Verify containers
docker ps

# Test connection
curl http://localhost:7000/clue/1
```

### 📸 SCREENSHOT #1
- [ ] Show `docker ps` with 3 containers (app, mongo, redis)
- [ ] Show first `curl` response with MongoDB source
- [ ] Show timestamp

---

## 📋 STEP 1: Rate Limiting Attack

### Terminal 2
```bash
# Run 6 times rapidly (or use step1.bat)
curl http://localhost:7000/clue/1
curl http://localhost:7000/clue/1
curl http://localhost:7000/clue/1
curl http://localhost:7000/clue/1
curl http://localhost:7000/clue/1
curl http://localhost:7000/clue/1
```

Expected: 429 error with message about rate limiting

### 📸 SCREENSHOT #2
- [ ] Show 429 error response
- [ ] Show "Rate Limiting" concept message
- [ ] Show next clue about temp_key
- [ ] Show timestamp

---

## 📋 STEP 2: TTL Race

### Terminal 2 - Get Redis Container
```bash
docker ps
# Note the redis container ID (e.g., abc123def456)
```

### Terminal 3 - Redis CLI
```bash
docker exec -it <redis_container_id> redis-cli
```

### Inside redis-cli
```redis
SETEX temp_key 10 unlock
```

### Terminal 2 - IMMEDIATELY (within 10 seconds!)
```bash
curl http://localhost:7000/clue/2
# Or run: step2.bat
```

### 📸 SCREENSHOT #3
- [ ] Show redis-cli with SETEX command
- [ ] Show successful curl response with clue 2
- [ ] Show timestamp proving it was within 10 seconds
- [ ] Bonus: Show `TTL temp_key` output

---

## 📋 STEP 3: Pub/Sub Event

### Terminal 3 - Redis CLI (still connected)
```redis
PUBLISH treasure_channel unlock
```

Expected: Returns (integer) 1 (one subscriber received the message)

### Terminal 1 - Check Server Logs
Look for: "Event-Driven Architecture: Pub/Sub triggered the unlock!"

### Terminal 3 - Verify State Change
```redis
GET golden_key
```

Expected: "unlocked"

### 📸 SCREENSHOT #4
- [ ] Show PUBLISH command and result
- [ ] Show server logs with unlock message
- [ ] Show GET golden_key returning "unlocked"
- [ ] Show timestamp

---

## 📋 STEP 4: Treasure Vault

### Terminal 2 - First Request
```bash
curl http://localhost:7000/treasure
```

Expected: source = "MongoDB" (not shown but implied), treasure = "FLAG{redis_king_2026}"

### Terminal 2 - Second Request (immediate)
```bash
curl http://localhost:7000/treasure
```

Expected: Same response (now cached in Redis)

### 📸 SCREENSHOT #5
- [ ] Show both curl responses
- [ ] Show the final flag: FLAG{redis_king_2026}
- [ ] Show congratulations message
- [ ] Show timestamp

---

## 🎯 Success Criteria

✅ All 5 screenshots taken with timestamps
✅ Used curl for all HTTP requests
✅ Used redis-cli for all Redis operations
✅ Did not modify server code
✅ Did not manually edit Redis keys (except as instructed)
✅ Retrieved final flag: `FLAG{redis_king_2026}`

---

## 🔧 Troubleshooting

### If temp_key expires before curl:
```redis
# In redis-cli, run again:
SETEX temp_key 10 unlock
# Then immediately run curl in Terminal 2
```

### If golden_key is still locked:
```redis
# In redis-cli:
GET golden_key
# If it shows "locked", run PUBLISH again:
PUBLISH treasure_channel unlock
```

### To reset everything:
```bash
# Stop containers
docker-compose down

# Start fresh
docker-compose up --build
```

---

## 📚 Concepts Demonstrated

1. **Rate Limiting**: Redis INCR + EXPIRE to track request counts
2. **TTL (Time-To-Live)**: SETEX for temporary keys
3. **Pub/Sub**: PUBLISH/SUBSCRIBE for event-driven architecture
4. **Caching**: Read-through cache pattern with SETEX
5. **Distributed State**: Shared state across services via Redis

---

## 🏆 Final Flag
`FLAG{redis_king_2026}`
