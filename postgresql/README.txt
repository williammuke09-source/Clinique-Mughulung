MIGRATION POSTGRESQL
=====================

1. Créer une base PostgreSQL dédiée.
2. Exécuter postgresql/schema.sql.
3. Définir CLINIQUE_DATABASE_URL.
4. Définir CLINIQUE_SECRET_KEY avec une valeur forte.
5. Installer requirements.txt.
6. Lancer l'application.
7. Vérifier les 7 rôles et les modules du cahier des charges.
8. Mettre en place pg_dump + restauration testée.
9. Activer HTTPS devant Flask.
10. Faire la recette fonctionnelle avant mise en production.

Le programme sélectionne PostgreSQL lorsque CLINIQUE_DATABASE_URL est défini.
Sans cette variable, il reste en mode SQLite de développement.

La sauvegarde intégrée à l'interface est volontairement réservée à SQLite.
En production PostgreSQL, les sauvegardes passent par pg_dump afin de rester
compatibles avec l'architecture PostgreSQL prévue par le cahier des charges.
