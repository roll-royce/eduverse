<!-- src/main/webapp/admin.jsp -->
<!doctype html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.3.1/dist/css/bootstrap.min.css">
    <title>Eduverse - Admin Panel</title>
    <style>
        body {
            background: url('https://wallpaperaccess.com/full/1801075.jpg') no-repeat center center fixed;
            background-size: cover;
        }
        .admin-container {
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
            <div class="col-md-8 admin-container">
                <h2 class="text-center">Admin Panel</h2>
                <div class="mb-4">
                    <h4>Manage E-books</h4>
                    <button class="btn btn-success" data-toggle="modal" data-target="#addBookModal">Add New E-book</button>
                </div>
                <table class="table table-bordered">
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Title</th>
                            <th>Author</th>
                            <th>Action</th>
                        </tr>
                    </thead>
                    <tbody>
                        <!-- Sample Data -->
                        <tr>
                            <td>1</td>
                            <td>Sample E-book</td>
                            <td>Author Name</td>
                            <td>
                                <button class="btn btn-danger btn-sm">Delete</button>
                            </td>
                        </tr>
                        <!-- Add more rows as needed -->
                    </tbody>
                </table>
            </div>
        </div>
    </div>

    <!-- Add E-book Modal -->
    <div class="modal fade" id="addBookModal" tabindex="-1" role="dialog" aria-labelledby="addBookModalLabel" aria-hidden="true">
        <div class="modal-dialog" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="addBookModalLabel">Add New E-book</h5>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body">
                    <form>
                        <div class="form-group">
                            <label for="bookTitle">Title</label>
                            <input type="text" class="form-control" id="bookTitle" placeholder="Enter book title" required>
                        </div>
                        <div class="form-group">
                            <label for="bookAuthor">Author</label>
                            <input type="text" class="form-control" id="bookAuthor" placeholder="Enter author name" required>
                        </div>
                        <button type="submit" class="btn btn-primary">Add E-book</button>
                    </form>
                </div>
            </div>
        </div>
    </div>

    <!-- Optional JavaScript -->
    <script src="https://code.jquery.com/jquery-3.3.1.slim.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/popper.js@1.14.7/dist/umd/popper.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@4.3.1/dist/js/bootstrap.min.js"></script>
</body>
</html>