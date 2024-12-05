<!DOCTYPE html>
<html>
<head>
    <title>Ray's Grocery CheckOut Line</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f0f0f0;
            margin: 0;
            padding: 0;
            display: flex;
            flex-direction: column;
            justify-content: center;
            align-items: center;
            height: 100vh;
        }
        h1 {
            text-align: center;
            color: #333;
            margin-bottom: 20px;
        }
        form {
            display: flex;
            flex-direction: column;
            align-items: center;
        }
        input[type="text"], input[type="password"] {
            padding: 10px;
            margin-bottom: 15px;
            border: 1px solid #ccc;
            border-radius: 5px;
            width: 300px;
        }
        input[type="submit"], input[type="reset"] {
            padding: 10px 20px;
            margin: 5px;
            border: none;
            border-radius: 5px;
            background-color: #007bff;
            color: #fff;
            cursor: pointer;
            transition: background-color 0.3s;
        }
        input[type="submit"]:hover, input[type="reset"]:hover {
            background-color: #0056b3;
        }
    </style>
</head>
<body>

    <h1>Enter your customer ID and password to complete the transaction:</h1>
    <!-- Bonus marks, username/password verification -->

    <form method="get" action="order.jsp">
        <input type="text" name="customerId" size="50" placeholder="Enter Customer ID">
        <input type="password" name="password" size="50" placeholder="Enter Password">
        <input type="submit" value="Submit">
        <input type="reset" value="Reset">
    </form>

</body>
</html>
