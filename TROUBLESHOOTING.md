# Troubleshooting Guide

## Common Issues and Solutions

### 🔴 Issue 1: Docker containers won't start

**Symptoms:**
- Error: "port already in use"
- Containers exit immediately
- Can't connect to services

**Solutions:**

```bash
# Stop all containers
docker-compose down

# Remove old containers and volumes
docker-compose down -v

# Rebuild and start fresh
docker-compose up --build

# If port 7000 is in use, check what's using it:
netstat -ano | findstr :7000

# Kill the process using the port (replace PID):
taskkill /PID <PID> /F
```

---

### 🔴 Issue 2: temp_key expires before I can curl

**Symptoms:**
- Get 403 error: "Access denied. Set 'temp_key' in Redis..."
- Too slow to switch terminals

**Solutions:**

**Option 1: Use two terminals side-by-side**
- Terminal 1: redis-cli ready
- Terminal 2: curl command typed and ready (don't press Enter yet)
- In Terminal 1: `SETEX temp_key 10 unlock`
- Immediately switch to Terminal 2 and press Enter

**Option 2: Use longer TTL for testing (then redo with 10s for screenshot)**
```redis
# Test with 30 seconds first
SETEX temp_key 30 unlock
```

**Option 3: Use step2.bat**
- Have step2.bat ready to double-click
- Run SETEX in redis-cli
- Immediately double-click step2.bat

---

### 🔴 Issue 3: golden_key is still "locked"

**Symptoms:**
- `/treasure` returns 403: "The vault is locked"
- GET golden_key shows "locked"

**Solutions:**

```redis
# Check current status
GET golden_key

# If it's "locked", publish again
PUBLISH treasure_channel unlock

# Verify it changed
GET golden_key
# Should now show: "unlocked"
```

**Check server logs:**
- Look for: "Event-Driven Architecture: Pub/Sub triggered the unlock!"
- If you don't see this message, the subscriber might not be connected
- Restart docker-compose and try again

---

### 🔴 Issue 4: Can't find Redis container ID

**Symptoms:**
- `docker ps` shows many containers
- Not sure which one is Redis

**Solutions:**

```bash
# Filter for redis
docker ps | findstr redis

# Or look for IMAGE column showing "redis:7"
docker ps

# The CONTAINER ID is the first column
# Example: abc123def456
```

**Full example:**
```
CONTAINER ID   IMAGE       COMMAND                  ...
abc123def456   redis:7     "docker-entrypoint.s…"   ...  <- This one!
```

---

### 🔴 Issue 5: Rate limiting not triggering

**Symptoms:**
- Can hit `/clue/1` more than 5 times without 429 error

**Solutions:**

```bash
# Make sure you're hitting it rapidly (within 60 seconds)
# Use step1.bat for automated rapid requests

# Or copy-paste these all at once:
curl http://localhost:7000/clue/1 & curl http://localhost:7000/clue/1 & curl http://localhost:7000/clue/1 & curl http://localhost:7000/clue/1 & curl http://localhost:7000/clue/1 & curl http://localhost:7000/clue/1
```

**Check Redis:**
```redis
# See rate limit keys
KEYS rate_limit:*

# Check the counter
GET rate_limit:::ffff:172.18.0.1
```

---

### 🔴 Issue 6: curl command not found

**Symptoms:**
- Error: 'curl' is not recognized as an internal or external command

**Solutions:**

**Option 1: Install curl**
- Windows 10/11 should have curl built-in
- Try: `curl --version`
- If missing, download from: https://curl.se/windows/

**Option 2: Use PowerShell's Invoke-WebRequest**
```powershell
Invoke-WebRequest -Uri http://localhost:7000/clue/1
```

**Option 3: Enable curl in Windows**
```bash
# Run in PowerShell as Administrator
Add-WindowsCapability -Online -Name curl~~~~
```

---

### 🔴 Issue 7: Server logs not showing Pub/Sub message

**Symptoms:**
- PUBLISH returns (integer) 1
- But server logs don't show unlock message

**Solutions:**

**Check if server is running:**
```bash
docker ps
# Make sure "app" container is running
```

**Check server logs:**
```bash
# Get app container ID
docker ps

# View logs
docker logs <app_container_id>

# Or follow logs in real-time
docker logs -f <app_container_id>
```

**Restart if needed:**
```bash
docker-compose restart app
```

---

### 🔴 Issue 8: Caching not working in Step 4

**Symptoms:**
- Both treasure requests show same source
- Don't see caching behavior

**Solutions:**

**The treasure endpoint doesn't show "source" field in response!**
- This is expected - the treasure endpoint doesn't include source
- Caching is happening behind the scenes
- The response will be the same both times

**To verify caching, check Redis:**
```redis
# After first treasure request
KEYS *

# You won't see treasure cached because it's fetched fresh each time
# The caching is demonstrated in the clue endpoints
```

**Note:** The instructions mention observing caching, but the treasure endpoint always fetches from MongoDB. The caching concept is demonstrated in Steps 1-2 with the clue endpoints.

---

### 🔴 Issue 9: MongoDB connection errors

**Symptoms:**
- Server logs show: "MongooseError: Can't connect"
- App container keeps restarting

**Solutions:**

```bash
# Check if mongo container is running
docker ps | findstr mongo

# Check mongo logs
docker logs <mongo_container_id>

# Restart all services
docker-compose down
docker-compose up --build

# If still failing, remove volumes
docker-compose down -v
docker-compose up --build
```

---

### 🔴 Issue 10: Redis CLI commands not working

**Symptoms:**
- Commands return errors
- Syntax errors

**Solutions:**

**Common mistakes:**

❌ Wrong: `SETEX "temp_key" "10" "unlock"`
✅ Right: `SETEX temp_key 10 unlock`

❌ Wrong: `PUBLISH "treasure_channel" "unlock"`
✅ Right: `PUBLISH treasure_channel unlock`

❌ Wrong: `GET "golden_key"`
✅ Right: `GET golden_key`

**Redis CLI is case-sensitive for values but not commands:**
```redis
# These are equivalent:
SETEX temp_key 10 unlock
setex temp_key 10 unlock

# But these are different:
GET golden_key    # Returns "unlocked"
GET Golden_Key    # Returns (nil)
```

---

### 🔴 Issue 11: Screenshots don't show timestamp

**Solutions:**

**Option 1: Use timestamp.bat**
```bash
# Run before each screenshot
timestamp.bat
```

**Option 2: Add timestamp to prompt**
```bash
# In cmd, run:
prompt $D $T $P$G
```

**Option 3: Use PowerShell**
```powershell
# Shows timestamp with each command
Get-Date; curl http://localhost:7000/clue/1
```

**Option 4: Manual timestamp**
```bash
echo %date% %time%
curl http://localhost:7000/clue/1
```

---

### 🔴 Issue 12: Need to reset everything

**Complete reset procedure:**

```bash
# Stop all containers
docker-compose down

# Remove volumes (deletes all data)
docker-compose down -v

# Remove images (optional, forces rebuild)
docker rmi redis-treasure-docker-app

# Start fresh
docker-compose up --build
```

**Quick reset (keeps images):**
```bash
docker-compose restart
```

---

## 🆘 Emergency Commands

### Check everything is running:
```bash
docker ps
curl http://localhost:7000/clue/1
```

### View all logs:
```bash
docker-compose logs
```

### View specific service logs:
```bash
docker-compose logs app
docker-compose logs redis
docker-compose logs mongo
```

### Restart specific service:
```bash
docker-compose restart app
docker-compose restart redis
docker-compose restart mongo
```

### Nuclear option (complete cleanup):
```bash
docker-compose down -v
docker system prune -a
docker-compose up --build
```

---

## 📞 Still Stuck?

1. Check `COMPLETE_CHECKLIST.md` for detailed steps
2. Check `REDIS_CLI_SESSION.md` for Redis examples
3. Check `QUICK_REFERENCE.md` for correct command syntax
4. Verify all 3 containers are running: `docker ps`
5. Check server logs: `docker-compose logs app`
6. Try complete reset (see above)

---

## ✅ Verification Checklist

Before starting, verify:
- [ ] Docker Desktop is running
- [ ] No other services using ports 7000, 6379, 27017
- [ ] You're in the correct directory: `redis-treasure-docker`
- [ ] Files exist: server.js, Dockerfile, docker-compose.yml

After starting, verify:
- [ ] 3 containers running: `docker ps`
- [ ] Server responds: `curl http://localhost:7000/clue/1`
- [ ] Redis accessible: `docker exec -it <id> redis-cli`
- [ ] Server logs show: "Treasure Hunt Server running"
