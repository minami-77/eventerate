# 📚 Project Name : Eventerate
A web app that generates personalized event plans and activities while offering collaboration tools for teachers, event coordinators, and HR professionals.
<img width="1701" alt="eventerate" src="https://github.com/user-attachments/assets/93a4a83a-2d8e-4c55-8b31-b842e6038b68" />
App home: https://www.eventerate.com/

## Getting Started
### Setup

Install gems
```
bundle install
```

### ENV Variables
Create `.env` file
```
touch .env
```
Inside `.env`, set these variables. For any APIs, see group Slack channel.
```
CLOUDINARY_URL=your_own_cloudinary_url_key
```

### DB Setup
```
rails db:create
rails db:migrate
rails db:seed
```

### Run a server
```
rails s
```

## Built With
- [Rails 7](https://guides.rubyonrails.org/) - Backend / Front-end
- [Stimulus JS](https://stimulus.hotwired.dev/) - Front-end JS
- [Heroku](https://heroku.com/) - Deployment
- [PostgreSQL](https://www.postgresql.org/) - Database
- [Bootstrap](https://getbootstrap.com/) — Styling
- [Figma](https://www.figma.com) — Prototyping

## Team Members
- [Alex Wong](https://github.com/Munkleson)
- [Allan Sechrist](https://github.com/AllanSechrist)
- [Minami Takayama](https://github.com/minami-77)

## Contributing
Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.

## License
This project is licensed under the MIT License

Rails app generated with [lewagon/rails-templates](https://github.com/lewagon/rails-templates), created by the [Le Wagon coding bootcamp](https://www.lewagon.com) team.
