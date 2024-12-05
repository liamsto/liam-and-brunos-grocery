<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.ArrayList" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Update Cart</title>
</head>
<body>
<%
//extra page to allow the user to update the quantity of a product in their cart
String productId = request.getParameter("productId");
String quantityStr = request.getParameter("quantity");

if (productId == null || quantityStr == null) {
    out.println("<p style='color: red;'>Invalid product or quantity.</p>");
    return;
}

int quantity = 0;
try {
    quantity = Integer.parseInt(quantityStr);
    if (quantity < 1) {
        out.println("<p style='color: red;'>Quantity must be at least 1.</p>");
        return;
    }
} catch (NumberFormatException e) {
    out.println("<p style='color: red;'>Invalid format.</p>");
    return;
}

@SuppressWarnings({"unchecked"})
HashMap<String, ArrayList<Object>> productList = (HashMap<String, ArrayList<Object>>) session.getAttribute("productList");

//some basic error handling, even though these should never happen
if (productList == null) {
    out.println("<p style='color: red;'>Your shopping cart is empty.</p>");
    return;
}

ArrayList<Object> product = productList.get(productId);
if (product == null) {
    out.println("<p style='color: red;'>Product not found in your cart.</p>");
    return;
}

product.set(3, quantity);
session.setAttribute("productList", productList);
response.sendRedirect("showcart.jsp");
%>
</body>
</html>
