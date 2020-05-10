#!/bin/bash
set -e
docker-php-ext-install calendar

# delete smarty cache
rm -rf ${GSALES_HOME}/DATA/cache_smarty

# create dirs
mkdir -p ${GSALES_HOME}/DATA/cache_smarty
mkdir -p ${GSALES_HOME}/DATA/contract
mkdir -p ${GSALES_HOME}/DATA/documents
mkdir -p ${GSALES_HOME}/DATA/invoice
mkdir -p ${GSALES_HOME}/DATA/offer
mkdir -p ${GSALES_HOME}/DATA/refund

cat >$GSALES_HOME/DATA/index.html <<-EOF
<!DOCTYPE html>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<title>GSALES</title>
</head>
<body>
	<h1>Achtung, Sicherheitsproblem!</h1>
	<p>Dieses Verzeichnis darf auf keinen Fall frei zugänglich sein!</p>
	<p>Falls du diese Meldung in einem Browser lesen kannst, liegt ein Konfigurationsproblem mit deiner g*Sales Installation vor.</p>
	<p>Bitte versehe das gesamte /DATA Verzeichnis mit einem Passwort oder sperre es komplett für den Webserver.</p>
	<p><strong style="color:red">PDF-Rechnungen, -Angebote, -Gutschriften etc. sind momentan möglicherweise für jeden frei aufrufbar!</strong></p>
</body>
</html>
EOF

chown -R nginx:nginx ${GSALES_HOME}/DATA