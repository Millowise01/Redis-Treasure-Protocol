# Redis Commands Cheat Sheet

## Connecting to Redis CLI

```bash
# Get container ID
docker ps

# Connect to Redis container
docker exec -it <redis_container_id> redis-cli
```

## Step 2: TTL Challenge

```redis
# Create temp_key with 10 second expiration
SETEX temp_key 10 unlock

# Check if key exists
GET temp_key

# Check time remaining (in seconds)
TTL temp_key
```

## Step 3: Pub/Sub Challenge

```redis
# Publish unlock message to treasure_channel
PUBLISH treasure_channel unlock
```

## Verification Commands

```redis
# List all keys
KEYS *

# Check golden_key status
GET golden_key

# Check rate limit keys
KEYS rate_limit:*

# Check cache keys
KEYS clue_cache:*

# Delete a key (if needed for testing)
DEL temp_key

# Flush all Redis data (CAUTION: resets everything)
FLUSHALL
```

## Expected Key States

### Initial State:
- `golden_key` = "locked"

### After Step 2:
- `temp_key` = "unlock" (expires in 10 seconds)

### After Step 3:
- `golden_key` = "unlocked"

### Rate Limiting:
- `rate_limit:<ip>` = counter (expires in 60 seconds)

### Caching:
- `clue_cache:1` = cached clue data (expires in 120 seconds)
- `clue_cache:2` = cached clue data (expires in 120 seconds)
