#!/bin/bash

# Couchbase Database Backup

# Credentials are not exposed for security
#cd ~/backup
. ./credentials.sh

# Backup File Name
AZURE_BACKUP_FILE=<name-of-the-backup-file>

# iDefault Backup Directory Name
BKUP_DIR=<name-of-backup-dir>

# Azure Blob Storage Name
AZURE_BLOB_NAME=<your-fav-name>-$(date +%d%m%Y%H%M%S).tar.gz

# removing existing folder or files inside backup_dir
rm -rf $BKUP_DIR/storage && mkdir $BKUP_DIR/storage
# CB Backup Utility 
cbbackup $HOST $BKUP_DIR/storage -u $CB_USER -p $CB_PASS --single-node  -b $BUCKET_NAME

# cd to backup dir for compressing the files

cd $BKUP_DIR/storage


tar cvzf $AZURE_BACKUP_FILE .

echo "Uploading the couchbase tar files..."
az storage blob upload  --account-name  $AZURE_STORAGE_ACCOUNT  --account-key $AZURE_STORAGE_ACCESS_KEY  --container $container_name  --file  $BKUP_DIR/storage/$AZURE_BACKUP_FILE --name  $AZURE_BLOB_NAME 

echo "Azure Blob output files list"
az storage blob list --container-name $container_name --output table
