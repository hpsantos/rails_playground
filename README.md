# README

This project is mostly meant to try out specific features from RoR 8.
It is not production-ready code in any way, nor is the focus to have things optimised.

It does touch on the following topics:

- ActionCable + SolidCable (with one standalone client implementation and another integrated with turbo_stream_from)
- Kamal deployment to clean server
- Tailwind integration on RoR
- Stimulus for javascript feature augmentation

# Running the project

To run the project, follow these steps:

1. **Install dependencies**:

   ```sh
   bundle install
   ```

2. **Set up the database**:

   ```sh
   rails db:create
   rails db:migrate
   rails db:seed
   ```

3. **Start the Rails server**:

   ```sh
   bin/dev
   ```

4. **Access the application**:
   Open your browser and navigate to `http://localhost:3000`
