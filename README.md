# Redis-Treasure-Protocol

## 🚀 Quick Start Guide

### Step 1: Navigate to Project
```bash
cd c:\Redis-Treasure-Protocol\redis-treasure-docker
```

### Step 2: Start Docker Services
```bash
docker-compose up --build
```

### Step 3: Choose Your Path

**📚 For Beginners**: Start with **[VISUAL_GUIDE.md](VISUAL_GUIDE.md)** for an illustrated walkthrough

**📋 For Execution**: Follow **[COMPLETE_CHECKLIST.md](COMPLETE_CHECKLIST.md)** step-by-step

**🎮 For Interactive**: Run **[master.bat](redis-treasure-docker/master.bat)** for a menu-driven experience

**🗺️ For Navigation**: Check **[INDEX.md](INDEX.md)** to find the right document

---

## 📚 Documentation Files

### 🌟 Start Here
| File | Purpose | Best For |
|------|---------|----------|
| **[VISUAL_GUIDE.md](VISUAL_GUIDE.md)** | Illustrated guide with ASCII art | Visual learners |
| **[FINAL_SUMMARY.md](FINAL_SUMMARY.md)** | Complete overview + quick start | Getting the big picture |
| **[INDEX.md](INDEX.md)** | Navigation hub for all docs | Finding the right guide |

### 📖 Execution Guides
| File | Purpose | Best For |
|------|---------|----------|
| **[COMPLETE_CHECKLIST.md](COMPLETE_CHECKLIST.md)** | Step-by-step with screenshots | Following along during execution |
| **[QUICK_REFERENCE.md](QUICK_REFERENCE.md)** | All commands in one place | Quick command lookup |
| **[EXECUTION_GUIDE.md](EXECUTION_GUIDE.md)** | Alternative detailed walkthrough | Alternative perspective |

### 🔧 Technical References
| File | Purpose | Best For |
|------|---------|----------|
| **[REDIS_CLI_SESSION.md](redis-treasure-docker/REDIS_CLI_SESSION.md)** | Complete Redis CLI examples | Learning Redis commands |
| **[REDIS_COMMANDS.md](redis-treasure-docker/REDIS_COMMANDS.md)** | Redis command reference | Quick syntax lookup |

### 🆘 Help & Support
| File | Purpose | Best For |
|------|---------|----------|
| **[TROUBLESHOOTING.md](TROUBLESHOOTING.md)** | Common issues + solutions | When things go wrong |

---

## 🔧 Helper Scripts

All scripts are in `redis-treasure-docker/` folder:

| Script | Purpose | Usage |
|--------|---------|-------|
| **[master.bat](redis-treasure-docker/master.bat)** | Interactive menu for all steps | Double-click or run in terminal |
| **[step1.bat](redis-treasure-docker/step1.bat)** | Automated rate limiting attack (6 requests) | Run for Step 1 |
| **[step2.bat](redis-treasure-docker/step2.bat)** | Quick clue 2 access | Run immediately after SETEX |
| **[step4.bat](redis-treasure-docker/step4.bat)** | Claim treasure twice (demo caching) | Run for Step 4 |
| **[timestamp.bat](redis-treasure-docker/timestamp.bat)** | Display current timestamp | Run before screenshots |

---

## 🎯 Challenge Overview

**Mission**: Retrieve `FLAG{redis_king_2026}` from the MongoDB vault

**The Journey**:
1. ⚡ **Step 1**: Break the rate limiter (trigger 429 error)
2. ⏱️ **Step 2**: Create a temporary key with 10-second TTL
3. 📡 **Step 3**: Publish unlock event via Redis Pub/Sub
4. 🏆 **Step 4**: Claim the treasure (observe caching in action)

**Concepts Demonstrated**:
- Rate Limiting (INCR + EXPIRE)
- Time-To-Live (SETEX)
- Pub/Sub (PUBLISH/SUBSCRIBE)
- Read-Through Caching
- Event-Driven Architecture

---

## 📸 Screenshot Requirements

You must take **5 screenshots** with timestamps:

1. **Screenshot #1**: docker ps + first curl response (Step 0)
2. **Screenshot #2**: 429 rate limit error (Step 1)
3. **Screenshot #3**: SETEX command + successful clue/2 access (Step 2)
4. **Screenshot #4**: PUBLISH command + server logs (Step 3)
5. **Screenshot #5**: Two treasure requests showing caching (Step 4)

---

## ⚠️ Rules (Strict Compliance Required)

### ✅ You MUST:
- Use `curl` for all HTTP requests
- Use `redis-cli` inside Docker container for Redis operations
- Take screenshots after EVERY stage
- Show full terminal window with timestamps
- Follow the sequence exactly

### ❌ You MUST NOT:
- Modify server.js code
- Manually edit Redis keys to unlock treasure (except as instructed)
- Access MongoDB directly
- Use Postman, browser, or GUI tools
- Skip steps or change the order

**Failure to follow sequence = 0 marks**

---

## 🔑 Essential Commands

### Docker
```bash
docker-compose up --build          # Start all services
docker ps                          # List running containers
docker exec -it <id> redis-cli     # Connect to Redis
```

### HTTP Requests (curl)
```bash
curl http://localhost:7000/clue/1      # Get clue 1
curl http://localhost:7000/clue/2      # Get clue 2 (needs temp_key)
curl http://localhost:7000/treasure    # Claim treasure (needs unlock)
```

### Redis CLI
```redis
SETEX temp_key 10 unlock               # Step 2: Create temp key
PUBLISH treasure_channel unlock        # Step 3: Unlock vault
GET golden_key                         # Verify unlock status
```

---

## 🏆 Expected Final Flag

```
FLAG{redis_king_2026}
```

---

## 🆘 Troubleshooting

### temp_key expired before curl?
```redis
SETEX temp_key 10 unlock  # Run again, then immediately curl
```

### golden_key still locked?
```redis
PUBLISH treasure_channel unlock  # Publish again
GET golden_key                   # Verify it's "unlocked"
```

### Need to reset everything?
```bash
docker-compose down
docker-compose up --build
```

**For more issues**: See [TROUBLESHOOTING.md](TROUBLESHOOTING.md)

---

## 📖 Recommended Reading Order

### For First-Time Users:
1. **[VISUAL_GUIDE.md](VISUAL_GUIDE.md)** - See the big picture with illustrations
2. **[COMPLETE_CHECKLIST.md](COMPLETE_CHECKLIST.md)** - Follow step-by-step
3. **[REDIS_CLI_SESSION.md](redis-treasure-docker/REDIS_CLI_SESSION.md)** - Reference during Redis CLI usage
4. **[TROUBLESHOOTING.md](TROUBLESHOOTING.md)** - When you need help

### For Quick Execution:
1. **[QUICK_REFERENCE.md](QUICK_REFERENCE.md)** - Copy commands
2. Use helper scripts: **master.bat** or individual step scripts
3. **[REDIS_COMMANDS.md](redis-treasure-docker/REDIS_COMMANDS.md)** - Quick syntax check

### For Navigation:
1. **[INDEX.md](INDEX.md)** - Find the right document for your needs

---

## 🎓 Learning Outcomes

By completing this challenge, you will master:
- ✅ Redis-based rate limiting implementation
- ✅ TTL (Time-To-Live) for temporary data
- ✅ Pub/Sub for event-driven systems
- ✅ Caching strategies for performance
- ✅ Distributed state management

---

## 📂 Complete File Structure

```
Redis-Treasure-Protocol/
│
├── README.md                          # This file - project overview
├── INDEX.md                           # Navigation hub
├── VISUAL_GUIDE.md                    # 🎨 Illustrated guide
├── FINAL_SUMMARY.md                   # 📋 Complete overview
├── COMPLETE_CHECKLIST.md              # ✅ Step-by-step execution
├── QUICK_REFERENCE.md                 # ⚡ Quick commands
├── EXECUTION_GUIDE.md                 # 📖 Alternative walkthrough
├── TROUBLESHOOTING.md                 # 🆘 Problem solving
│
└── redis-treasure-docker/
    ├── server.js                      # Server code (DO NOT MODIFY)
    ├── Dockerfile                     # Docker config
    ├── docker-compose.yml             # Docker Compose config
    ├── package.json                   # Node.js dependencies
    │
    ├── master.bat                     # 🎮 Interactive menu
    ├── step1.bat                      # Rate limiting script
    ├── step2.bat                      # Clue 2 access script
    ├── step4.bat                      # Treasure claiming script
    ├── timestamp.bat                  # Timestamp display
    │
    ├── REDIS_CLI_SESSION.md           # Redis CLI examples
    └── REDIS_COMMANDS.md              # Redis command reference
```

---

**Ready to hunt for treasure?**

🎨 **Visual Learner?** → Start with [VISUAL_GUIDE.md](VISUAL_GUIDE.md)

📋 **Ready to Execute?** → Follow [COMPLETE_CHECKLIST.md](COMPLETE_CHECKLIST.md)

🎮 **Want Interactive?** → Run [master.bat](redis-treasure-docker/master.bat)

🗺️ **Need Navigation?** → Check [INDEX.md](INDEX.md)

**Good luck, treasure hunter!** 🏴‍☠️