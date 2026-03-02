# 🏴‍☠️ Redis Treasure Hunt - Visual Guide

```
    _______________
   /               \
  /  REDIS TREASURE \
 /    PROTOCOL      \
|  ________________  |
| |                | |
| | FLAG{redis_    | |
| | king_2026}     | |
| |________________| |
|____________________|
   |______________|
```

## 🗺️ The Treasure Map

```
                    START HERE
                        |
                        v
    ┌───────────────────────────────────────┐
    │  STEP 0: IGNITE THE INFRASTRUCTURE    │
    │  ⚙️  docker-compose up --build         │
    │  ✅ Verify 3 containers running        │
    │  📸 Screenshot #1                      │
    └───────────────┬───────────────────────┘
                    |
                    v
    ┌───────────────────────────────────────┐
    │  STEP 1: BREAK THE GATEKEEPER         │
    │  ⚡ Send 6 rapid requests              │
    │  🚫 Trigger 429 Rate Limit Error       │
    │  📸 Screenshot #2                      │
    └───────────────┬───────────────────────┘
                    |
                    v
    ┌───────────────────────────────────────┐
    │  STEP 2: THE RACE AGAINST TIME        │
    │  ⏱️  SETEX temp_key 10 unlock          │
    │  🏃 Quick! curl /clue/2 (10 seconds!)  │
    │  📸 Screenshot #3                      │
    └───────────────┬───────────────────────┘
                    |
                    v
    ┌───────────────────────────────────────┐
    │  STEP 3: THE GHOST SIGNAL             │
    │  📡 PUBLISH treasure_channel unlock    │
    │  🔓 golden_key → "unlocked"            │
    │  📸 Screenshot #4                      │
    └───────────────┬───────────────────────┘
                    |
                    v
    ┌───────────────────────────────────────┐
    │  STEP 4: CLAIM THE TREASURE           │
    │  🏆 curl /treasure (twice)             │
    │  💾 Observe: MongoDB → Redis Cache     │
    │  📸 Screenshot #5                      │
    └───────────────┬───────────────────────┘
                    |
                    v
            🎉 SUCCESS! 🎉
        FLAG{redis_king_2026}
```

---

## 🎮 The Challenge Flow

```
┌─────────────┐
│   DOCKER    │  Start your engines!
│  COMPOSE    │  docker-compose up --build
└──────┬──────┘
       │
       v
┌─────────────┐
│    APP      │  Node.js Server
│  :7000      │  Express + Mongoose + Redis
└──────┬──────┘
       │
       ├──────────────┐
       │              │
       v              v
┌─────────────┐  ┌─────────────┐
│   MONGODB   │  │    REDIS    │
│   :27017    │  │    :6379    │
│             │  │             │
│ Stores:     │  │ Manages:    │
│ • Clues     │  │ • Rate Limit│
│ • Treasure  │  │ • TTL Keys  │
│ • Flag      │  │ • Pub/Sub   │
│             │  │ • Cache     │
└─────────────┘  └─────────────┘
```

---

## 🔑 Key Concepts Visualized

### 1️⃣ Rate Limiting
```
Request 1 ──> Redis INCR ──> Counter: 1 ✅
Request 2 ──> Redis INCR ──> Counter: 2 ✅
Request 3 ──> Redis INCR ──> Counter: 3 ✅
Request 4 ──> Redis INCR ──> Counter: 4 ✅
Request 5 ──> Redis INCR ──> Counter: 5 ✅
Request 6 ──> Redis INCR ──> Counter: 6 ❌ 429 ERROR!
```

### 2️⃣ Time-To-Live (TTL)
```
t=0s:  SETEX temp_key 10 unlock  ──> temp_key="unlock" (TTL: 10s)
t=3s:  GET temp_key              ──> "unlock" (TTL: 7s)
t=7s:  curl /clue/2              ──> ✅ SUCCESS (TTL: 3s)
t=11s: GET temp_key              ──> (nil) ❌ EXPIRED
```

### 3️⃣ Pub/Sub Event-Driven
```
Terminal 1 (Server)          Terminal 2 (Redis CLI)
     │                              │
     │  Listening on                │
     │  treasure_channel            │
     │         ◄────────────────────┤ PUBLISH treasure_channel unlock
     │                              │
     ├─ Received: "unlock"          │
     │                              │
     ├─ SET golden_key "unlocked"   │
     │                              │
     └─ Log: "Pub/Sub triggered!"   │
```

### 4️⃣ Read-Through Caching
```
First Request:
  curl /clue/1 ──> Check Redis ──> (miss) ──> MongoDB ──> Return + Cache

Second Request:
  curl /clue/1 ──> Check Redis ──> (hit!) ──> Return from Cache
                                              (No MongoDB query!)
```

---

## 📊 Redis Key States

### Initial State (After docker-compose up)
```
┌─────────────────────────────────┐
│ Redis Keys:                     │
│                                 │
│ golden_key = "locked" 🔒        │
│                                 │
└─────────────────────────────────┘
```

### After Step 1 (Rate Limiting)
```
┌─────────────────────────────────┐
│ Redis Keys:                     │
│                                 │
│ golden_key = "locked" 🔒        │
│ rate_limit:IP = 6 (TTL: 45s)   │
│                                 │
└─────────────────────────────────┘
```

### After Step 2 (TTL)
```
┌─────────────────────────────────┐
│ Redis Keys:                     │
│                                 │
│ golden_key = "locked" 🔒        │
│ temp_key = "unlock" (TTL: 10s) │
│ clue_cache:1 (TTL: 120s)       │
│ clue_cache:2 (TTL: 120s)       │
│                                 │
└─────────────────────────────────┘
```

### After Step 3 (Pub/Sub)
```
┌─────────────────────────────────┐
│ Redis Keys:                     │
│                                 │
│ golden_key = "unlocked" 🔓      │
│ temp_key = (expired)            │
│ clue_cache:1 (TTL: 90s)        │
│ clue_cache:2 (TTL: 90s)        │
│                                 │
└─────────────────────────────────┘
```

---

## 🎯 Command Cheat Sheet

```
╔════════════════════════════════════════════════════════════╗
║                    DOCKER COMMANDS                         ║
╠════════════════════════════════════════════════════════════╣
║ docker-compose up --build    │ Start all services          ║
║ docker ps                    │ List containers             ║
║ docker exec -it <id> redis-cli │ Connect to Redis         ║
║ docker-compose down          │ Stop all services           ║
╚════════════════════════════════════════════════════════════╝

╔════════════════════════════════════════════════════════════╗
║                     CURL COMMANDS                          ║
╠════════════════════════════════════════════════════════════╣
║ curl http://localhost:7000/clue/1    │ Get clue 1         ║
║ curl http://localhost:7000/clue/2    │ Get clue 2         ║
║ curl http://localhost:7000/treasure  │ Get treasure       ║
╚════════════════════════════════════════════════════════════╝

╔════════════════════════════════════════════════════════════╗
║                    REDIS COMMANDS                          ║
╠════════════════════════════════════════════════════════════╣
║ SETEX temp_key 10 unlock           │ Create temp key      ║
║ PUBLISH treasure_channel unlock    │ Unlock vault         ║
║ GET golden_key                     │ Check status         ║
║ KEYS *                             │ List all keys        ║
║ TTL temp_key                       │ Check time left      ║
╚════════════════════════════════════════════════════════════╝
```

---

## 📸 Screenshot Checklist

```
□ Screenshot #1: Infrastructure Setup
  ├─ docker ps output (3 containers)
  ├─ First curl /clue/1 response
  └─ Timestamp visible

□ Screenshot #2: Rate Limiting
  ├─ 429 error response
  ├─ Rate limiting message
  └─ Timestamp visible

□ Screenshot #3: TTL Challenge
  ├─ SETEX command in redis-cli
  ├─ Successful curl /clue/2 response
  ├─ Timestamp showing < 10 seconds
  └─ Optional: TTL temp_key output

□ Screenshot #4: Pub/Sub Event
  ├─ PUBLISH command result
  ├─ Server logs with unlock message
  ├─ GET golden_key showing "unlocked"
  └─ Timestamp visible

□ Screenshot #5: Treasure Claim
  ├─ First curl /treasure response
  ├─ Second curl /treasure response
  ├─ FLAG{redis_king_2026} visible
  └─ Timestamp visible
```

---

## 🏆 Victory Conditions

```
✅ All 5 screenshots captured with timestamps
✅ Used curl for all HTTP requests
✅ Used redis-cli for all Redis operations
✅ Did not modify server.js
✅ Did not manually edit Redis keys (except as instructed)
✅ Retrieved: FLAG{redis_king_2026}

    _______________
   /               \
  /   CONGRATULATIONS \
 /    YOU ARE A       \
|   REDIS MASTER!     |
|  ________________   |
| |                | |
| |   🏆 🎉 🏆    | |
| |________________| |
|____________________|
```

---

## 🚀 Quick Start Commands

Copy and paste these in order:

```bash
# Terminal 1: Start services
cd c:\Redis-Treasure-Protocol\redis-treasure-docker
docker-compose up --build

# Terminal 2: Verify and test
docker ps
curl http://localhost:7000/clue/1

# Step 1: Rate limiting (run 6 times)
curl http://localhost:7000/clue/1

# Get Redis container ID
docker ps | findstr redis

# Step 2: Connect to Redis
docker exec -it <CONTAINER_ID> redis-cli

# In redis-cli:
SETEX temp_key 10 unlock

# Back in Terminal 2 (IMMEDIATELY):
curl http://localhost:7000/clue/2

# Back in redis-cli:
PUBLISH treasure_channel unlock
GET golden_key

# Back in Terminal 2:
curl http://localhost:7000/treasure
curl http://localhost:7000/treasure
```

---

## 📚 Documentation Quick Links

- 📖 **[INDEX.md](INDEX.md)** - Navigation guide
- 🌟 **[FINAL_SUMMARY.md](FINAL_SUMMARY.md)** - Complete overview
- ✅ **[COMPLETE_CHECKLIST.md](COMPLETE_CHECKLIST.md)** - Step-by-step guide
- ⚡ **[QUICK_REFERENCE.md](QUICK_REFERENCE.md)** - Command reference
- 🆘 **[TROUBLESHOOTING.md](TROUBLESHOOTING.md)** - Problem solving

---

**Ready to hunt for treasure? Let's go!** 🏴‍☠️⚓🗺️
