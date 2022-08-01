============
MODIFY_list:
============
- blog bucket names: within CFN and SETTINGS.PY
- github repo path
- TOKEN

TO_DO_list:
===========
- After getting RDS created, update RDS Endpoint within SETTINGS.PY file
- Add files into FAILOVER BUCKET yourself, but don't forget to make them public via ACL
- UNCOMMENT Certificate parts if didn't request any yet (DO NOT FORGET TO MODIFY CertificateArn WITHIN ALBListener, too) (!!!WARNING: it might take hours !!!)

NOTES:
======
- Best practice: RDS (DB) password shouldn't be hardcoded, refer to the comments within template
- Before deleting CFN stack, empty S3 buckets created by CFN
- If CFN unable to delete some components (e.g. blog bucket), remove them manually
- To save Free Tier usage per month, you can reduce MinSize, MaxSize and DesiredCapacity to 1