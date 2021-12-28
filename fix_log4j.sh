#!/bin/bash

#1.7	2021-08-27		For version 10.0 feature package 2108 (FP2108)
#1.6	2021-05-25		For version 10.0 feature package 2105 (FP2105)
#1.5	2021-03-01		For version 10.0 feature package 2102 (FP2102)
#1.4	2020-11-11		For version 10.0 feature package 2011 (FP2011)
#1.3	2020-08-20		For version 10.0 feature package 2008 (FP2008)
#1.2	2020-04-20		For version 10.0 patch level 02 (PL02)
#1.1	2019-12-11		For version 10.0 patch level 01 (PL01)
#1.0	2019-10-25		First version

echo -e "log4j fix tool Ver. 1.0\n"

get_sap_version_apply(){
	TMPSAPVER=$(/usr/sap/SAPBusinessOne/setup -v | tail -1)
	SAPVER=${TMPSAPVER#*: }
	PL=${SAPVER#* }

	echo -e "SAP Business One Server Components"
	echo -e "Version: ${SAPVER}\n"

	case $PL in
		PL03)
			echo -e "Applying fix for FP2008..."
			process_war "LicenseControlCenter" "/usr/sap/SAPBusinessOne/ServerTools/License/webapps" "2.7"
			process_war "ServiceLayerController" "/usr/sap/SAPBusinessOne/ServiceLayer/ServiceLayerController/webapps" "2.7"
			process_war "ExtensionManager" "/usr/sap/SAPBusinessOne/ServerTools/ExtensionManager/webapps" "2.7"
			;;
		PL04)
			echo -e "Applying fix for FP2011..."
			process_war "LicenseControlCenter" "/usr/sap/SAPBusinessOne/ServerTools/License/webapps" "2.7"
			process_war "ServiceLayerController" "/usr/sap/SAPBusinessOne/ServiceLayer/ServiceLayerController/webapps" "2.7"
			process_war "ExtensionManager" "/usr/sap/SAPBusinessOne/ServerTools/ExtensionManager/webapps" "2.7"
			;;
		PL05)
			echo -e "Applying fix for FP2102..."
			process_war "LicenseControlCenter" "/usr/sap/SAPBusinessOne/ServerTools/License/webapps" "2.7"
			process_war "ServiceLayerController" "/usr/sap/SAPBusinessOne/ServiceLayer/ServiceLayerController/webapps" "2.7"
			process_war "ExtensionManager" "/usr/sap/SAPBusinessOne/ServerTools/ExtensionManager/webapps" "2.7"
			;;
		PL06)
			echo -e "Applying fix for FP2105..."
			process_war "LicenseControlCenter" "/usr/sap/SAPBusinessOne/ServerTools/License/webapps" "2.7"
			process_war "ServiceLayerController" "/usr/sap/SAPBusinessOne/ServiceLayer/ServiceLayerController/webapps" "2.7"
			process_war "ReportingService" "/usr/sap/SAPBusinessOne/ServerTools/ReportingService/webapps" "2.14.0"
			process_war "ExtensionManager" "/usr/sap/SAPBusinessOne/ServerTools/ExtensionManager/webapps" "2.7"
			;;
		PL07)
			echo -e "Applying fix for FP2108..."
			process_war "LicenseControlCenter" "/usr/sap/SAPBusinessOne/ServerTools/License/webapps" "2.7"
			process_war "ServiceLayerController" "/usr/sap/SAPBusinessOne/ServiceLayer/ServiceLayerController/webapps" "2.7"
			process_war "ReportingService" "/usr/sap/SAPBusinessOne/ServerTools/ReportingService/webapps" "2.14.0"
			process_war "ExtensionManager" "/usr/sap/SAPBusinessOne/ServerTools/ExtensionManager/webapps" "2.7"
			;;
		*)
			echo -e "This version is intended for SAP Business One Server Components version 10.0"
			echo -e "FP2008, FP2011, FP2102, FP2105, FP2108"
			exit 99
			;;
	esac
}

process_war(){
	echo -e "\n=> Processing ${1}\n"	
	echo -e "Entering directory ${2}"
	cd "${2}"
	echo -e "Extracting file log4j-core-${3}.jar"
	unzip "${1}".war WEB-INF/lib/log4j-core-"${3}".jar -d .
	echo -e "Deleting class JndiLookup.class from jar file"
	echo "zip -q -d WEB-INF/lib/log4j-core-${3}.jar org/apache/logging/log4j/core/lookup/JndiLookup.class"
	zip -q -d WEB-INF/lib/log4j-core-"${3}".jar org/apache/logging/log4j/core/lookup/JndiLookup.class
	echo -e "Adding new log4j-core-${3}.jar file to war component"
	zip "${1}".war WEB-INF/lib/log4j-core-"${3}".jar
	echo -e "Deleting working directory"
	rm -r WEB-INF
	echo -e "Restoring permissions of war component"
	chown b1service0:b1service0 "${1}".war
}

pre_check(){
	if [[ -d /usr/sap/SAPBusinessOne ]]
	then
		get_sap_version_apply
	else
		echo -e "The SAP Business One Server Components directory does not exist. Please check the installation."
		exit 98
	fi
}

pre_check