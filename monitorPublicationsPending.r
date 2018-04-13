# \file      monitorPublicationsPending.r
# \brief     Counts the number of pending (de/re)publication(s) or publication of metadata change(s)
#            that are pending longer then allowedTimeDiff parameter.
# \author    Niek Bats
# \copyright Copyright (c) 2018, Utrecht University. All rights reserved.

check {
        *count = 0;
        msiGetIcatTime(*currentTime, "unix");

        foreach(*row in SELECT COLL_MODIFY_TIME
                        WHERE  META_COLL_ATTR_NAME  = 'org_vault_status'
                        AND    META_COLL_ATTR_VALUE = 'APPROVED_FOR_PUBLICATION') {
                *time = *row.COLL_MODIFY_TIME;

                if((int(*currentTime)) - int(*time) > *allowedTimeDiff) {
                        *count = *count+1;
                }
        }

        foreach(*row in SELECT COLL_MODIFY_TIME
                        WHERE  META_COLL_ATTR_NAME  = 'org_vault_status'
                        AND    META_COLL_ATTR_VALUE = 'PENDING_DEPUBLICATION') {
                *time = *row.COLL_MODIFY_TIME;

                if((int(*currentTime)) - int(*time) > *allowedTimeDiff) {
                        *count = *count+1;
                }
        }

        foreach(*row in SELECT COLL_MODIFY_TIME
                        WHERE  META_COLL_ATTR_NAME  = 'org_vault_status'
                        AND    META_COLL_ATTR_VALUE = 'PENDING_REPUBLICATION') {
                *time = *row.COLL_MODIFY_TIME;

                if((int(*currentTime)) - int(*time) > *allowedTimeDiff) {
                        *count = *count+1;
                }
        }

        foreach(*row in SELECT COLL_MODIFY_TIME
                        WHERE  META_COLL_ATTR_NAME  = 'org_cronjob_publication_update'
                        AND    META_COLL_ATTR_VALUE = 'CRONJOB_PENDING') {
                *time = *row.COLL_MODIFY_TIME;

                if((int(*currentTime)) - int(*time) > *allowedTimeDiff) {
                        *count = *count+1;
                }
        }
        writeLine("stdout", *count);
}

input *allowedTimeDiff = 86400 # in seconds: 86400 seconds = 1 day
output ruleExecOut
