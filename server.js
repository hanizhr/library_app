
const express = require('express');
const mysql = require('mysql2');
const bodyParser = require('body-parser'); 
const cors = require('cors');
const app = express();

app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: true }));
app.use(cors());
app.use(express.json());

const db = mysql.createConnection({
    host: 'localhost',
    user: 'root',
    password: 'hani9964',
    database: 'bookstore'
});
db.connect(err => {
    if (err) {
        console.error('Error connecting to MySQL:', err);
    return;
}
console.log('Connected to MySQL database.');
});

app.post('/addBook', (req, res) => {
        const { title, price, owner, Bby, genre, author, publication_date, picture } = req.body;
    
        console.log(req.body);
    
        const sql = 'INSERT INTO book (title, price, owner, Bby, genre, author, publication_date, picture) VALUES(?, ?, ?, ?, ?, ?, ?, ?)';
    
        db.query(sql, [title, price, owner, Bby, genre, author, publication_date, picture], (err, result) => {
            if (err) {
                return res.status(500).json({ error: err });
            }
            res.status(200).json({
                message: 'Book added successfully',
                bookId: result.insertId
            });
        });
    });

    app.put('/editBook/:id', (req, res) => {
        const { id } = req.params;
        const { title, price, owner, Bby, genre, author, publication_date, picture } = req.body;
    
        console.log(req.body);
    
        const sql = `UPDATE book SET title = ?, price = ?, owner = ?, Bby = ?, genre = ?, author = ?, publication_date = ?, picture = ? WHERE id = ?`;
    
        db.query(sql, [title, price, owner, Bby, genre, author, publication_date, picture, id], (err, result) => {
            if (err) {
                console.error('SQL Error:', err);
                return res.status(500).json({ error: err });
            }
    
            if (result.affectedRows === 0) {
                return res.status(404).json({ message: 'Book not found' });
            }
    
            res.status(200).json({
                message: 'Book updated successfully',
            });
        });
    });
    
    

app.delete('/deleteBook/:id', (req, res) => {
        const { id } = req.params;
    
        const sql = 'DELETE FROM book WHERE id = ?';
    
        db.query(sql, [id], (err, result) => {
            if (err) {
                return res.status(500).json({ error: err });
            }
    
            if (result.affectedRows === 0) {
                return res.status(404).json({ message: 'Book not found' });
            }
    
            res.status(200).json({
                message: 'Book deleted successfully',
            });
        });
    });
    
app.get('/books', (req, res) => {
    const sql = 'SELECT * FROM book WHERE Bby = -1';
    db.query(sql, (err, result) => {
        if (err) {
            return res.status(500).json({ error: err });
        }
        res.status(200).json(result);
    });
    });

    app.get('/books/:id', (req, res) => {
        const userId = req.params.id;
        const sql = 'SELECT * FROM book WHERE owner = ?';
        db.query(sql, [userId], (err, result) => {
            if (err) {
                return res.status(500).json({ error: err });
            }
            res.status(200).json(result);
        });
    });
    
app.get('/getBook/:id', (req, res) => {
        const userId = req.params.id;
        const sql = 'SELECT * FROM book WHERE id = ?';
        db.query(sql, [userId], (err, result) => {
            if (err) {
                return res.status(500).json({ error: err });
            }
            res.status(200).json(result);
        });
    });
    app.get('/getBook/:title', (req, res) => {
        const title = req.params.title; 
        const sql = 'SELECT * FROM book WHERE title = ?'; 
        db.query(sql, [title], (err, result) => { 
            if (err) {
                return res.status(500).json({ error: err });
            }
            res.status(200).json(result); 
        });
    });

app.post('/register', (req, res) => {
    const { name, email } = req.body;
    const sql = 'INSERT INTO user (name, email) VALUES (?, ?)';
    db.query(sql, [name, email], (err, result) => {
        if (err) {
            return res.status(500).json({ error: err });
        }
        res.status(201).json({ message: 'User registered successfully.', userId: result.insertId });
    });
});

app.get('/users', (req, res) => {
    const sql = 'SELECT * FROM user';
    db.query(sql, (err, result) => {
        if (err) {
            return res.status(500).json({ error: err });
        }
        res.status(200).json(result);
    });
});

app.get('/user/:id', (req, res) => {
    const { id } = req.params;
    const sql = 'SELECT * FROM user WHERE id = ?';
    db.query(sql, [id], (err, result) => {
        if (err) {
            return res.status(500).json({ error: err });
        }
        if (result.length === 0) {
            return res.status(404).json({ message: 'User not found.' });
        }
        res.status(200).json(result[0]);
    });
});

app.get('/login/:name', (req, res) => {
    const { name } = req.params;
    const sql = 'SELECT * FROM user WHERE name = ?';
    db.query(sql, [name], (err, result) => {
    if (err) {
    return res.status(500).json({ error: err });
    }if (result.length === 0) {
    return res.status(404).json({ message: 'User notfound.' });
    }
    res.json(result[0]);
    });
});

app.delete('/user/:id', (req, res) => {
    const { id } = req.params;
    const sql = 'DELETE FROM user WHERE id = ?';
    db.query(sql, [id], (err, result) => {
        if (err) {
            return res.status(500).json({ error: err });
        }
        if (result.affectedRows === 0) {
            return res.status(404).json({ message: 'User not found.' });
        }
        res.status(200).json({ message: 'User deleted successfully.' });
    });
});

app.put('/user/:id', (req, res) => {
    const { id } = req.params;
    const { name, email } = req.body;
    const sql = 'UPDATE user SET name = ?, email = ? WHERE id = ?';
    db.query(sql, [name, email, id], (err, result) => {
        if (err) {
            return res.status(500).json({ error: err });
        }
        if (result.affectedRows === 0) {
            return res.status(404).json({ message: 'User not found.' });
        }
        res.status(200).json({ message: 'User updated successfully.' });
    });
});

app.post('/addToCart', (req, res) => {
    const { user_id, book_id, quantity } = req.body;
  
    db.beginTransaction((err) => {
      if (err) {
        return res.status(500).json({ error: err });
      }

      const insertCartSql = 'INSERT INTO Cart (user_id, book_id, quantity) VALUES (?, ?, ?) ON DUPLICATE KEY UPDATE quantity = quantity + ?';
      db.query(insertCartSql, [user_id, book_id, quantity, quantity], (err, result) => {
        if (err) {
          return db.rollback(() => {
            res.status(500).json({ error: err });
          });
        }
  
        const updateBookSql = 'UPDATE book SET Bby = ? WHERE id = ?';
        db.query(updateBookSql, [user_id, book_id], (err, result) => {
          if (err) {
            return db.rollback(() => {
              res.status(500).json({ error: err });
            });
          }
  
          db.commit((err) => {
            if (err) {
              return db.rollback(() => {
                res.status(500).json({ error: err });
              });
            }
            res.status(200).json({ message: 'Book added to cart and Bby updated successfully' });
          });
        });
      });
    });
  });
  

app.delete('/removeFromCart', (req, res) => {
    const { user_id, book_id } = req.body;

    const updateSql = 'UPDATE book SET Bby = -1 WHERE id = ?'; 

    db.query(updateSql, [book_id], (err, result) => {
        if (err) {
            return res.status(500).json({ error: err });
        }

        const deleteSql = 'DELETE FROM Cart WHERE user_id = ? AND book_id = ?';

        db.query(deleteSql, [user_id, book_id], (err, result) => {
            if (err) {
                return res.status(500).json({ error: err });
            }

            res.status(200).json({ message: 'Book removed from cart and Bby set to -1 successfully' });
        });
    });
});


app.get('/getCart/:user_id', (req, res) => {
    const user_id = req.params.user_id;
    const sql = 'SELECT * FROM Cart WHERE user_id = ?';
  
    db.query(sql, [user_id], (err, result) => {
      if (err) {
        return res.status(500).json({ error: err });
      }
      res.status(200).json(result); 
    });
  });
  

// Update quantity in cart
app.put('/updateCart', (req, res) => {
    const { buyer_id, book_id, quantity } = req.body;

    const sql = 'UPDATE Cart SET quantity = ? WHERE buyer_id = ? AND book_id = ?';

    db.query(sql, [quantity, buyer_id, book_id], (err, result) => {
        if (err) {
            return res.status(500).json({ error: err });
        }
        res.status(200).json({ message: 'Cart updated successfully' });
    });
});

// Clear entire cart
app.delete('/clearCart/:buyer_id', (req, res) => {
    const { buyer_id } = req.params;

    const sql = 'DELETE FROM Cart WHERE buyer_id = ?';

    db.query(sql, [buyer_id], (err, result) => {
        if (err) {
            return res.status(500).json({ error: err });
        }
        res.status(200).json({ message: 'Cart cleared successfully' });
    });
});

    // Start the server
const PORT = 3000;
app.listen(PORT, () => {
        console.log(`Server is running on http://localhost:${PORT}`);
    });


