ARG OFFEN_BACKUP_VERSION=v2.12.0
ARG POSTGRES_VERSION=14.2

FROM offen/docker-volume-backup:${OFFEN_BACKUP_VERSION} AS base
FROM postgres:${POSTGRES_VERSION}-alpine AS postgres

COPY --from=base /usr/bin/backup /usr/bin/backup
COPY docker-entrypoint.sh backup.sh /
RUN chmod +x /docker-entrypoint.sh /backup.sh \
    && mkdir /pre.d \
    && mkdir /post.d

ENTRYPOINT ["/docker-entrypoint.sh"]
