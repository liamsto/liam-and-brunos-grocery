<!DOCTYPE html>
<html>
<head>
    <title>Login Screen</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            background-color: #f9f9f9;
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 100vh;
        }
        .login-container {
            width: 90%;
            max-width: 400px;
            background-color: #ffffff;
            border-radius: 10px;
            box-shadow: 0px 4px 10px rgba(0, 0, 0, 0.1);
            padding: 30px;
            text-align: center;
        }
        h2 {
            color: #333333;
            font-size: 24px;
            margin-bottom: 20px;
        }
        form {
            margin: 0;
            display: flex;
            flex-direction: column;
        }
        label {
            font-size: 16px;
            color: #444444;
            margin-bottom: 8px;
            text-align: left;
        }
        input {
            font-size: 14px;
            padding: 10px;
            margin-bottom: 20px;
            border: 1px solid #cccccc;
            border-radius: 5px;
            width: 100%;
            box-sizing: border-box;
        }
        input:focus {
            border-color: #007bff;
            outline: none;
        }
        .submit {
            background-color: #007bff;
            color: white;
            font-size: 16px;
            font-weight: bold;
            padding: 12px;
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
            font-size: 14px;
            margin-bottom: 20px;
        }
        .create-account {
            margin-top: 20px;
            text-align: center;
        }
        .create-account h3 {
            font-size: 18px;
            color: #555555;
            margin-bottom: 10px;
        }
        .create-account .submit {
            background-color: #28a745;
        }
        .create-account .submit:hover {
            background-color: #218838;
        }
    </style>
</head>
<body>

<div class="login-container">
    <h2>Log In to Your Account</h2>
    
    <% if (session.getAttribute("loginMessage") != null) { %>
        <p class="error-message"><%= session.getAttribute("loginMessage").toString() %></p>
    <% } %>
    
    <form name="MyForm" method="post" action="validateLogin.jsp">
        <label for="username">Username:</label>
        <input type="text" name="username" id="username" maxlength="20" placeholder="Enter your username" required>
        
        <label for="password">Password:</label>
        <input type="password" name="password" id="password" maxlength="20" placeholder="Enter your password" required>
        
        <button class="submit" type="submit" name="Submit2">Log In</button>
    </form>
    
    <div class="create-account">
        <h3>Don't have an account? No problem!</h3>
        <form name="CreateAccount" method="post" action="createAccount.jsp">
            <button class="submit" type="submit" name="Submit3">Create an Account</button>
        </form>
    </div>
</div>

</body>
</html>
