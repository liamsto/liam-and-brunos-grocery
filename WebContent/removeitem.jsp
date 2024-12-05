<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Map" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Remove Item from Cart</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f0f0f0;
            margin: 20px;
        }
        h1, h2 {
            text-align: center;
        }
        p {
            text-align: center;
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
            margin: 10px;
        }
        a:hover {
            background-color: #0056b3;
        }
    </style>
</head>
<body>
<%
//bonus marks - helper page to remove items 
String productId = request.getParameter("productId");
@SuppressWarnings({"unchecked"})
HashMap<String, ArrayList<Object>> productList = (HashMap<String, ArrayList<Object>>) session.getAttribute("productList");

if (productList != null && productId != null) {
    if (productList.containsKey(productId)) {
        productList.remove(productId);
        out.println("<p>Product with ID " + productId + " has been removed from your shopping cart.</p>");
    } else {
        //probably never going to happen
        out.println("<p>Product not found in your shopping cart.</p>");
    }
} else {
    out.println("<p>Your shopping cart is empty or invalid product ID.</p>");
}
session.setAttribute("productList", productList);
%>

<h2><a href="showcart.jsp">Back to Cart</a></h2>
<h2><a href="listprod.jsp">Continue Shopping</a></h2>
</body>
</html>
