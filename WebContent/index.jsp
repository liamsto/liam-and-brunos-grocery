<!DOCTYPE html>
<html>
<head>
    <title>Liam's Grocery Main Page</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 0;
            background-color: #f0f0f0;
        }
        header {
            background-color: #007bff;
            color: white;
            padding: 20px 0;
            text-align: center;
            font-size: 2em;
        }
        nav {
            margin: 20px auto;
            text-align: center;
        }
        nav a {
            display: inline-block;
            margin: 10px;
            padding: 10px 20px;
            color: white;
            background-color: #007bff;
            text-decoration: none;
            border-radius: 5px;
            font-size: 1.2em;
            transition: background-color 0.3s;
        }
        nav a:hover {
            background-color: #0056b3;
        }
        .user-info {
            margin: 20px auto;
            text-align: center;
            font-size: 1.1em;
            color: #333;
        }
        footer {
            text-align: center;
            margin: 20px 0;
        }
        footer a {
            color: #007bff;
            text-decoration: none;
        }
        footer a:hover {
            text-decoration: underline;
        }
        .test-links {
            margin-top: 20px;
            text-align: center;
            font-size: 1em;
        }
        .test-links a {
            color: #007bff;
            text-decoration: none;
        }
        .test-links a:hover {
            text-decoration: underline;
        }
    </style>
</head>
<body>

<header>
    Welcome to Liam's Grocery!
</header>

<nav>
    <a href="login.jsp">Login</a>
    <a href="listprod.jsp">Begin Shopping</a>
    <a href="listorder.jsp">List All Orders</a>
    <a href="customer.jsp">Customer Info</a>
    <a href="admin.jsp">Administrators</a>
    <a href="logout.jsp">Log Out</a>
</nav>

<%
    String userName = (String) session.getAttribute("authenticatedUser");
    if (userName != null) {
%>
<div class="user-info">
    Signed in as: <strong><%= userName %></strong>
</div>
<%
    }
%>


</body>
</html>
