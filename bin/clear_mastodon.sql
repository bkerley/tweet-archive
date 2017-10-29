delete from archive.mastodons;
delete from media_attachments;
delete from preview_cards_statuses;
delete from preview_cards;
delete from stream_entries where activity_type = 'Status';
delete from statuses;

-- should be non-destructive!
DROP SCHEMA archive CASCADE;
