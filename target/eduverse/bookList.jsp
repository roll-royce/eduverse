<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Book List - EduVerse</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            background-color: lavender;
        }
        .container {
            margin-top: 50px;
        }
        .card {
            border-radius: 10px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
        }
    </style>
</head>
<body>
    <div class="container">
        <h2 class="text-center">Available Books</h2>
        <div class="row">
            <div class="col-md-4">
                <div class="card p-3">
                    <img src="book-cover.jpg" class="card-img-top" alt="Book Cover">
                    <div class="card-body">
                        <h5 class="card-title">Book Title</h5>
                        <p class="card-text">Author: Author Name</p>
                        <p class="card-text">Category: Fiction</p>
                        <p class="card-text">Price: $10.00</p>
                        <a href="bookDetails.jsp" class="btn btn-primary">View Details</a>
                    </div>
                </div>
            </div>
            <!-- Repeat similar blocks for more books -->
        </div>
    </div>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
