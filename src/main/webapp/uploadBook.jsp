<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Upload Books - EduVerse</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            background-color: lavender;
        }
        .container {
            max-width: 600px;
            margin-top: 50px;
            background: white;
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
        }
    </style>
</head>
<body>
    <div class="container">
        <h2 class="text-center">Upload Your Books</h2>
        <form action="processUpload.jsp" method="post" enctype="multipart/form-data">
            <div id="bookUploadContainer">
                <div class="book-upload">
                    <div class="mb-3">
                        <label for="title" class="form-label">Book Title</label>
                        <input type="text" class="form-control" id="title" name="title[]" required>
                    </div>
                    <div class="mb-3">
                        <label for="author" class="form-label">Author</label>
                        <input type="text" class="form-control" id="author" name="author[]" required>
                    </div>
                    <div class="mb-3">
                        <label for="description" class="form-label">Description</label>
                        <textarea class="form-control" id="description" name="description[]" rows="3" required></textarea>
                    </div>
                    <div class="mb-3">
                        <label for="category" class="form-label">Category</label>
                        <select class="form-control" id="category" name="category[]" required>
                            <option value="Fiction">Fiction</option>
                            <option value="Non-fiction">Non-fiction</option>
                            <option value="Science">Science</option>
                            <option value="Technology">Technology</option>
                        </select>
                    </div>
                    <div class="mb-3">
                        <label for="price" class="form-label">Price (INR)</label>
                        <input type="number" class="form-control" id="price" name="price[]" step="0.01" required>
                    </div>
                    <div class="mb-3">
                        <label for="bookFile" class="form-label">Upload E-Book</label>
                        <input type="file" class="form-control" id="bookFile" name="bookFile[]" required>
                    </div>
                </div>
            </div>
            <button type="button" class="btn btn-secondary" onclick="addBookUpload()">Add Another Book</button>
            <button type="submit" class="btn btn-primary w-100 mt-3">Upload Books</button>
        </form>
    </div>
    <script>
        function addBookUpload() {
            const container = document.getElementById('bookUploadContainer');
            const bookUpload = document.querySelector('.book-upload').cloneNode(true);
            container.appendChild(bookUpload);
        }
    </script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>