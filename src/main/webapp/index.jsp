<!doctype html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.3.1/dist/css/bootstrap.min.css">
    <title>Eduverse - User Dashboard</title>
    <style>
        body {
            background: url('https://wallpaperaccess.com/full/1801075.jpg') no-repeat center center fixed;
            background-size: cover;
        }
        .dashboard-container {
            background: rgba(255, 255, 255, 0.8);
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 0 20px rgba(0, 0, 0, 0.5);
        }
    </style>
</head>
<body>
    <div class="container mt-5">
        <div class="row justify-content-center">
            <div class="col-md-8 dashboard-container">
                <h2 class="text-center">Welcome to Eduverse</h2>
                <h4>User Profile</h4>
                <p><strong>Name:</strong> [User Name]</p>
                <p><strong>Email:</strong> [User Email]</p>
                <p><strong>Phone:</strong> [User Phone]</p>
                <p><strong>Address:</strong> [User Address]</p>
                <p><strong>Age:</strong> [User Age]</p>
                <p><strong>Gender:</strong> [User Gender]</p>
                <p><strong>Occupation:</strong> [User Occupation]</p>
                <hr>
                <h4>Your Uploaded Books</h4>
                <table class="table table-bordered">
                    <thead>
                        <tr>
                            <th>Title</th>
                            <th>Author</th>
                            <th>Action</th>
                        </tr>
                    </thead>
                    <tbody>
                        <!-- Sample Data -->
                        <tr>
                            <td>Sample E-book</td>
                            <td>Author Name</td>
                            <td>
                                <button class="btn btn-danger btn-sm">Delete</button>
                            </td>
                        </tr>
                        <!-- Add more rows dynamically based on user uploads -->
                    </tbody>
                </table>
                <hr>
                <h4>Upload New E-book</h4>
                <form action="uploadBook.jsp" method="post" enctype="multipart/form-data">
                    <div class="form-group">
                        <label for="bookTitle">Title</label>
                        <input type="text" class="form-control" id="bookTitle" name="bookTitle" placeholder="Enter book title" required>
                    </div>
                    <div class="form-group">
                        <label for="bookAuthor">Author</label>
                        <input type="text" class="form-control" id="bookAuthor" name="bookAuthor" placeholder="Enter author name" required>
                    </div>
                    <div class="form-group">
                        <label for="bookFile">Upload File (PDF/EPUB)</label>
                        <input type="file" class="form-control-file" id="bookFile" name="bookFile" accept=".pdf,.epub" required>
                    </div>
                    <button type="submit" class="btn btn-primary">Upload E-book</button>
                </form>
            </div>
        </div>
    </div>

    <!-- Optional JavaScript -->
    <script src="https://code.jquery.com/jquery-3.3.1.slim.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/popper.js@1.14.7/dist/umd/popper.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@4.3.1/dist/js/bootstrap.min.js"></script>
</body>
</html>