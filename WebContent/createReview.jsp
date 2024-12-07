<!DOCTYPE html>
<html>
<head>
    <title>New Account Screen</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 20px;
            background-color: #f0f0f0;
        }
        .createAccount {
            text-align: center;
            margin-top: 100px;
        }
        h2 {
            text-align: center;
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

<div class="createAccount">
    <h3> Share Your Thoughts With Others! </h3>
    <br>
    <br>
    <h4> Leave a review here: </h4>
    <%
    if (session.getAttribute("loginMessage") != null) {
        out.println("<p class='error-message'>" + session.getAttribute("loginMessage").toString() + "</p>");
    }
    %>

    <form name="MyForm" method="post" action="product.jsp">
        <tr>
            <td>Rate (1 to 5):</td>
            <br>
            <td>
                <label><input type="radio" name="rating" value="1" required> 1</label>
                <label><input type="radio" name="rating" value="2"> 2</label>
                <label><input type="radio" name="rating" value="3"> 3</label>
                <label><input type="radio" name="rating" value="4"> 4</label>
                <label><input type="radio" name="rating" value="5"> 5</label>
            </td>
        </tr>
        <br> <br>   
        <td>Provide Your Reasoning:</td>    
        <br> 
             <textarea name="review" id="review" rows="10" cols="100" required></textarea>
        <br/>
        <br>
        <input class="submit" type="submit" name="Submit2" value="Submit my Review!">
    </form>
</div>

</body>
</html>
