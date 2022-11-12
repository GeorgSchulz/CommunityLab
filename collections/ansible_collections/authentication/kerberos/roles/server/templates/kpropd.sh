#!/bin/sh

slavekdcs=security2.{{ domain }}

/usr/sbin/kdb5_util dump /var/lib/krb5kdc/replica_datatrans
error=$?

if [ $error -ne 0 ]; then

	echo "Kerberos database dump failed"
	echo "with exit code $error. Exciting."
	exit 1
fi

for kdc in $slavekdcs; do

	/usr/sbin/kprop $kdc > /dev/null
	error=$?

	if [ $error -ne 0 ]; then

		echo "Propagation of database to host $kdc"
		echo "failed with exit code $error."
	fi
done

exit 0
