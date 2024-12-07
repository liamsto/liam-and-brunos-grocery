<!DOCTYPE html>
<html>
<head>
    <title>Leave a Review</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            background-color: #f9f9f9;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
        }
        .review-container {
            max-width: 600px;
            width: 100%;
            background-color: #ffffff;
            border-radius: 10px;
            box-shadow: 0px 4px 10px rgba(0, 0, 0, 0.1);
            padding: 30px;
            text-align: center;
        }
        h3 {
            color: #333333;
            font-size: 24px;
            margin-bottom: 20px;
        }
        p {
            color: #666666;
            font-size: 16px;
            margin-bottom: 30px;
        }
        form {
            text-align: left;
        }
        label {
            font-size: 16px;
            color: #444444;
            display: block;
            margin-bottom: 8px;
            font-weight: bold;
        }
        .rating-options {
            display: flex;
            justify-content: space-between;
            margin-bottom: 20px;
        }
        .rating-options label {
            display: flex;
            align-items: center;
            gap: 5px;
        }
        textarea {
            width: 100%;
            height: 100px;
            border: 1px solid #cccccc;
            border-radius: 5px;
            padding: 10px;
            font-size: 14px;
            color: #333333;
            margin-bottom: 20px;
            resize: none;
        }
        textarea:focus {
            border-color: #007bff;
            outline: none;
        }
        .submit {
            background-color: #007bff;
            color: white;
            padding: 12px 20px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            font-size: 16px;
            font-weight: bold;
            width: 100%;
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
    </style>
</head>
<body>

<div class="review-container">
    <h3>Share Your Thoughts!</h3>
    <p>We value your feedback. Please rate the product and leave a detailed review.</p>

    <%
    if (session.getAttribute("loginMessage") != null) {
        out.println("<p class='error-message'>" + session.getAttribute("loginMessage").toString() + "</p>");
    }
    
    String productId = request.getParameter("productId");
    if (productId == null || productId.isEmpty()) {
        out.println("<p style='color: red;'>Invalid product ID. Please go back and try again.</p>");
        return;
    }
    %>

    <form method="POST" action="submitReview.jsp">
        <!-- Hidden field to pass productId -->
        <input type="hidden" name="productId" value="<%= productId %>">
        
        <!-- Rating Section -->
        <label>Rate the Product:</label>
        <div class="rating-options">
            <label><input type="radio" name="rating" value="1" required> 1</label>
            <label><input type="radio" name="rating" value="2"> 2</label>
            <label><input type="radio" name="rating" value="3"> 3</label>
            <label><input type="radio" name="rating" value="4"> 4</label>
            <label><input type="radio" name="rating" value="5"> 5</label>
        </div>
        
        <!-- Review Section -->
        <label>Write Your Review:</label>
        <textarea name="review" placeholder="Tell us about your experience..." required></textarea>
        
        <!-- Submit Button -->
        <button class="submit" type="submit">Submit Review</button>
    </form>
</div>

</body>
</html>
