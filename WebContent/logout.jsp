<%@ page language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Logout</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f0f0f0;
            margin: 20px;
            text-align: center;
        }
        h1 {
            color: #007bff;
        }
        p {
            font-size: 1.2em;
        }
        a {
            text-decoration: none;
            color: #fff;
            background-color: #007bff;
            padding: 10px 20px;
            border-radius: 5px;
            transition: background-color 0.3s;
            display: inline-block;
            margin-top: 20px;
        }
        a:hover {
            background-color: #0056b3;
        }
    </style>
</head>
<body>
<%
    // Invalidate the session to log the user out
    if (session != null) {
        session.invalidate(); // Remove all session attributes and terminate the session
    }
%>
<h1>You have been logged out</h1>
<p>Thank you for visiting! You are now logged out.</p>
<a href="login.jsp">Log In Again</a> <!-- Redirect user to login page -->
<a href="index.jsp">Go to Home</a> <!-- Optional link to home page -->
</body>
</html>
