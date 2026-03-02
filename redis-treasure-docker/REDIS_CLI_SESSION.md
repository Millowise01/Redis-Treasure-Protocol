# Redis CLI Session Guide

## Complete Redis CLI Workflow

### 1. Connect to Redis Container

```bash
# Terminal 2: Get container ID
docker ps

# Look for the line with "redis:7" - note the CONTAINER ID (first column)
# Example output:
# CONTAINER ID   IMAGE     ...
# abc123def456   redis:7   ...

# Connect to Redis CLI (replace abc123def456 with your actual ID)
docker exec -it abc123def456 redis-cli
```

### 2. You're Now Inside redis-cli

You should see a prompt like: `127.0.0.1:6379>`

### 3. Step 2 - Create Temporary Key

```redis
127.0.0.1:6379> SETEX temp_key 10 unlock
```

Expected output: `OK`

**IMMEDIATELY** (within 10 seconds) switch to Terminal 2 and run:
```bash
curl http://localhost:7000/clue/2
```

### 4. Optional - Verify the Key (if you're fast enough)

```redis
127.0.0.1:6379> GET temp_key
```

Expected output: `"unlock"`

```redis
127.0.0.1:6379> TTL temp_key
```

Expected output: `(integer) 7` (or whatever seconds remain)

### 5. Step 3 - Publish Unlock Event

```redis
127.0.0.1:6379> PUBLISH treasure_channel unlock
```

Expected output: `(integer) 1`

This means 1 subscriber received the message.

### 6. Verify the State Changed

```redis
127.0.0.1:6379> GET golden_key
```

Expected output: `"unlocked"` (changed from "locked")

### 7. Optional - Explore Redis State

```redis
# List all keys
127.0.0.1:6379> KEYS *

# Check rate limit keys
127.0.0.1:6379> KEYS rate_limit:*

# Check cache keys
127.0.0.1:6379> KEYS clue_cache:*

# Get a specific cache key
127.0.0.1:6379> GET clue_cache:1
```

### 8. Exit Redis CLI

```redis
127.0.0.1:6379> EXIT
```

Or press `Ctrl+C`

---

## Complete Session Example

```
C:\Redis-Treasure-Protocol\redis-treasure-docker> docker ps
CONTAINER ID   IMAGE                              COMMAND                  ...
abc123def456   redis:7                            "docker-entrypoint.s…"   ...
def456ghi789   mongo:7                            "docker-entrypoint.s…"   ...
ghi789jkl012   redis-treasure-docker-app          "docker-entrypoint.s…"   ...

C:\Redis-Treasure-Protocol\redis-treasure-docker> docker exec -it abc123def456 redis-cli
127.0.0.1:6379> SETEX temp_key 10 unlock
OK
127.0.0.1:6379> TTL temp_key
(integer) 8
127.0.0.1:6379> PUBLISH treasure_channel unlock
(integer) 1
127.0.0.1:6379> GET golden_key
"unlocked"
127.0.0.1:6379> KEYS *
1) "golden_key"
2) "rate_limit:::ffff:172.18.0.1"
3) "clue_cache:1"
127.0.0.1:6379> EXIT

C:\Redis-Treasure-Protocol\redis-treasure-docker>
```

---

## Screenshot Requirements for Redis CLI

### Screenshot #3 (Step 2):
- Show: `SETEX temp_key 10 unlock` command
- Show: `OK` response
- Show: Timestamp
- Bonus: Show `TTL temp_key` output

### Screenshot #4 (Step 3):
- Show: `PUBLISH treasure_channel unlock` command
- Show: `(integer) 1` response
- Show: `GET golden_key` returning `"unlocked"`
- Show: Timestamp
- Also capture server logs showing "Event-Driven Architecture: Pub/Sub triggered the unlock!"

---

## Troubleshooting

### If temp_key expires:
```redis
# Just run it again
127.0.0.1:6379> SETEX temp_key 10 unlock
# Then quickly switch terminals and curl
```

### If golden_key is still locked:
```redis
127.0.0.1:6379> GET golden_key
"locked"

# Run PUBLISH again
127.0.0.1:6379> PUBLISH treasure_channel unlock
(integer) 1

# Verify
127.0.0.1:6379> GET golden_key
"unlocked"
```

### If you need to reset:
```redis
# CAUTION: This deletes everything in Redis
127.0.0.1:6379> FLUSHALL
OK

# The server will reinitialize on next request
```

---

## Redis Commands Used

| Command | Purpose | Example |
|---------|---------|---------|
| `SETEX` | Set key with expiration | `SETEX temp_key 10 unlock` |
| `GET` | Get value of key | `GET golden_key` |
| `TTL` | Check time-to-live | `TTL temp_key` |
| `PUBLISH` | Send message to channel | `PUBLISH treasure_channel unlock` |
| `KEYS` | List keys matching pattern | `KEYS *` |
| `DEL` | Delete a key | `DEL temp_key` |
| `FLUSHALL` | Delete all keys | `FLUSHALL` |
| `EXIT` | Exit redis-cli | `EXIT` |
