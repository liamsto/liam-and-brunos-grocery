<!DOCTYPE html>
<html>
<head>
    <title>Login Screen</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 20px;
            background-color: #f0f0f0;
        }
        .login-container {
            text-align: center;
            margin-top: 100px;
        }
        h3 {
            font-size: 24px;
        }
        form {
            margin: 20px auto;
            display: inline-block;
            text-align: left;
        }
        table {
            margin: 0 auto;
        }
        td {
            padding: 8px;
        }
        .submit {
            background-color: #007bff;
            color: white;
            padding: 10px 20px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            transition: background-color 0.3s;
        }
        .submit:hover {
            background-color: #0056b3;
        }
        .error-message {
            color: red;
            margin-top: 10px;
        }
    </style>
</head>
<body>

<div class="login-container">
    <h3>Please Login</h3>

    <%
    if (session.getAttribute("loginMessage") != null) {
        out.println("<p class='error-message'>" + session.getAttribute("loginMessage").toString() + "</p>");
    }
    %>

    <form name="MyForm" method="post" action="validateLogin.jsp">
        <table>
            <tr>
                <td><label for="username">Username:</label></td>
                <td><input type="text" name="username" id="username" size="15" maxlength="20" required></td>
            </tr>
            <tr>
                <td><label for="password">Password:</label></td>
                <td><input type="password" name="password" id="password" size="15" maxlength="20" required></td>
            </tr>
        </table>
        <br/>
        <input class="submit" type="submit" name="Submit2" value="Log In">
    </form>
</div>

</body>
</html>
