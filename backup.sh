#!/bin/sh
[ -z "$BACKUP_DIRECTORY" ] && BACKUP_DIRECTORY="/backup/postgres"

# Make sure the backup directory exists
mkdir /backup 2> /dev/null
mkdir -p $BACKUP_DIRECTORY 2> /dev/null

# Run pre-backup scripts
find /pre.d -type f -exec sh "{}" ";"

# Run default backup
[ -n "$POSTGRES_PASSWORD" ] && export PGPASSWORD=$POSTGRES_PASSWORD
[ -z ${DISABLE_DEFAULT_BACKUP+x} ] && pg_dumpall --username "$POSTGRES_USER" --host "$POSTGRES_HOST" > "$BACKUP_DIRECTORY/all_dbs.sql"

# Upload backup files
backup

# Run post-backup scripts
find /post.d -type f -exec sh "{}" ";"

# Delete the snapshot
[ -z ${DISABLE_DEFAULT_BACKUP+x} ] && rm -rf $BACKUP_DIRECTORY
