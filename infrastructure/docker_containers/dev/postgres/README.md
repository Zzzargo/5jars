## Requirements for dev build
- Create a `.env` file in the directory the `compose.yaml` file is located with the following content:
```
POSTGRES_USER=[postgres_user]
POSTGRES_PASSWORD=[choose_a_password]
POSTGRES_DB=five_jars_dev
LOAD_SEEDS=[true/false]
```