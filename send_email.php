<?php
use PHPMailer\PHPMailer\PHPMailer;
use PHPMailer\PHPMailer\Exception;

require 'vendor/autoload.php'; // Ensure this path is correct

if ($_SERVER["REQUEST_METHOD"] == "POST") {
    $smtp_host = $_POST['smtp_host'];
    $smtp_port = $_POST['smtp_port'];
    $smtp_user = $_POST['smtp_user'];
    $smtp_pass = $_POST['smtp_pass'];
    $sender_email = $_POST['sender_email'];
    $to_email = $_POST['to_email'];
    $subject = $_POST['subject'];
    $message = $_POST['message'];

    $mail = new PHPMailer();
    $mail->isSMTP();
    $mail->Host = $smtp_host;
    $mail->SMTPAuth = true;
    $mail->Port = $smtp_port;
    $mail->Username = $smtp_user;
    $mail->Password = $smtp_pass;

    $mail->setFrom($sender_email, 'SMTP Server Tester');
    $mail->addAddress($to_email);
    $mail->Subject = $subject;
    $mail->Body = $message;

    // Enable verbose debug output
    $mail->SMTPDebug = 2;
    $mail->Debugoutput = function($str, $level) {
        echo $str . "<br>";
    };

    // Attempt to send the email
    if ($mail->send()) {
        echo "Email sent successfully to $to_email<br>";
    } else {
        echo "Failed to send email. Error: " . $mail->ErrorInfo . "<br>";
    }
}
