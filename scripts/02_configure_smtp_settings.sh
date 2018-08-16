#!/usr/local/bin/php
<?php
/**
 * @param $mysqli
 *
 * @return boolean
 */
function gsalesSmtpConfigIsUnchanged( $mysqli ) {
	$query  = "SELECT * FROM `" . $_ENV['MYSQL_DATABASE'] . "`.`send_actions` WHERE `id`='1';";
	$result = $mysqli->query( $query );

	if ( $result->num_rows > 0 ) {
		while ( $row = $result->fetch_assoc() ) {
			if ( implode( '|',
					$row ) == "1|Standard / Fallback|1|3|1||GSALES 2 Installation|noreply@meinedomain.local|0|||||||||0|0" ) {
				return true;
			}
		}
	}

	return false;
}

// only do anything if host is specified
if ( isset( $_ENV['SMTP_HOST'] ) && strlen( $_ENV['SMTP_HOST'] ) > 0  &&  $_ENV['SMTP_HOST'] != 'smtp.domain.de') {

	sleep(5);

	// include databse config of g*Sales
	require_once( $_ENV['GSALES_HOME'] . '/lib/inc.cfg.php' );

	$mysqli = new mysqli( $db[0]['host'], $db[0]['user'], $db[0]['password'], $db[0]['database'] );

	/* check connection */
	if ( $mysqli->connect_errno ) {
		printf( "Connection to database failed, please install g*Sales and restart docker container: %s\n",
			$mysqli->connect_error );
		exit();
	}

	print( "Check whether g*Sales SMTP settings are unchanged\n" );

	if ( gsalesSmtpConfigIsUnchanged( $mysqli ) ) {
		print( "g*Sales SMTP settings are unchanged!\n" );
		$query = '';

		if ( isset( $_ENV['SMTP_USERNAME'] ) && isset( $_ENV['SMTP_USERNAME'] ) ) {
			// smtp with authentification
			$mode = 1;
		} else {
			// smtp without authentification
			$mode = 2;
		}
		$query .= "UPDATE `" . $_ENV['MYSQL_DATABASE'] . "`.`send_actions` SET `method`='" . $mode . "' WHERE `id`='1';";

		if ( isset( $_ENV['SMTP_HOST'] ) ) {
			$query .= "UPDATE `" . $_ENV['MYSQL_DATABASE'] . "`.`send_actions` SET `server_host`='" . $_ENV['SMTP_HOST'] . "' WHERE `id`='1';";
		}

		if ( isset( $_ENV['SMTP_USERNAME'] ) ) {
			$query .= "UPDATE `" . $_ENV['MYSQL_DATABASE'] . "`.`send_actions` SET `server_user`='" . $_ENV['SMTP_USERNAME'] . "' WHERE `id`='1';";
		}

		if ( isset( $_ENV['SMTP_PASSWORD'] ) ) {
			$query .= "UPDATE `" . $_ENV['MYSQL_DATABASE'] . "`.`send_actions` SET `server_pass`='" . $_ENV['SMTP_PASSWORD'] . "' WHERE `id`='1';";
		}

		if ( isset( $_ENV['SMTP_PORT'] ) ) {
			$query .= "UPDATE `" . $_ENV['MYSQL_DATABASE'] . "`.`send_actions` SET `server_port`='" . $_ENV['SMTP_PORT'] . "' WHERE `id`='1';";
		}

		if ( isset( $_ENV['SMTP_SECURITY'] ) ) {
			$query .= "UPDATE `" . $_ENV['MYSQL_DATABASE'] . "`.`send_actions` SET `server_secure`='" . strtolower( $_ENV['SMTP_SECURITY'] ) . "' WHERE `id`='1';";
		}

		echo "Configure g*Sales SMTP settings";
		$mysqli->multi_query( $query );
	}

	/* close connection */
	$mysqli->close();
}
?>