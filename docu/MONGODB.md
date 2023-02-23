# Useful MongoDB commands

* Create a new user:
```
db.createUser({user: "user", pwd: passwordPrompt(), roles: [{role: "role", db: "db"}]});
```

* Grant role:
```
db.grantRolesToUser("user", [{role: "role", db: "db"}]);
```
