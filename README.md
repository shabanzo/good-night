# Good Night aka good-night

A simple API-based application to let users track when they go to bed and when they wake up.

## Contents

1. [Requirements for the MVP](https://github.com/shabanzo/good-night/blob/master/README.md#requirements-for-the-mvp)
2. [Improvements](https://github.com/shabanzo/good-night/blob/master/README.md#improvements)
3. [Getting Started](https://github.com/shabanzo/good-night/blob/master/README.md#getting-started)
4. [Testing](https://github.com/shabanzo/good-night/blob/master/README.md#testing)
5. [API Documentation](https://github.com/shabanzo/good-night/blob/master/README.md#api-documentation)
   - [Sleep Histories - Clock in API](https://github.com/shabanzo/good-night/blob/master/README.md#sleep-histories---clock-in-api)
   - [Sleep Histories - Clock out API](https://github.com/shabanzo/good-night/blob/master/README.md#sleep-histories---clock-out-api)
   - [Users API](https://github.com/shabanzo/good-night/blob/master/README.md#users-api)
   - [Relationships - Follow API](https://github.com/shabanzo/good-night/blob/master/README.md#relationships---follow-api)
   - [Relationships - Unfollow API](https://github.com/shabanzo/good-night/blob/master/README.md#relationships---unfollow-api)
   - [Sleep Histories - Following API](https://github.com/shabanzo/good-night/blob/master/README.md#sleep-histories---following-api)

## Requirements for the MVP

1. Clock-in operation, and return all clocked-in times, ordered by created time.
   - API: Sleep History - Clock in API, Sleep History - Clock out API
2. Users can follow and unfollow other users.
   - API: Users API, Relationship - Follow API, Relationship - Unfollow API
3. See their following' sleep histories over the past week, ordered by the length of their sleep.
   - API: Sleep History - Following API

## Improvements

1. Limit the clocked-in times to 5 at the latest, ordered by descending created time for performance-wise.
2. Pagination for sleep histories for performance-wise.
3. Add composite indexes to sleep histories:
   - user_id and created_at, for optimizing case number 1
   - user_id, clock_in_time, and duration_minutes, for optimizing case number 3

## Getting Started

1. Ensure you have installed Ruby in your machine, specifically for this application we're using Ruby v.3.2.0
2. Setup the application environment by executing this command:

```
bin/setup
```

3. The application is ready to run by executing this command:

```
rails s
```

## Testing

Execute this command:
```
rspec
```

## API Documentation

### Sleep Histories - Clock In API

API for recording the clocked-in data. The initial sleep history row will be created within this API.

#### Source code

- [link to the controller](https://github.com/shabanzo/good-night/blob/master/app/controllers/api/v1/users/sleep_histories_controller.rb#L5-L16)
- [link to the class service](https://github.com/shabanzo/good-night/blob/master/app/services/sleep_history/clock_in.rb)

```
POST /api/v1/users/:user_id/sleep_histories/clock_in
```

| Request Parameters | Type    | Descriptions         |
| ------------------ | ------- | -------------------- |
| user_id            | Integer | The current user ID. |

#### Request parameters example:

```
POST /api/v1/users/1/sleep_histories/clock_in
```

#### Success response example (status: 201):

```json
{
  "message": "Congratulations, your clock-in has been recorded successfully!",
  "data": [
    "2024-12-09T13:39:06.000Z",
    "2024-12-08T13:41:56.000Z",
    "2024-12-07T11:16:03.000Z",
    "2024-12-06T15:17:48.000Z",
    "2024-12-05T13:26:31.000Z",
  ]
}
```

#### Failed response example (status: 400):

```json
{
  "message": "Bad request; You have incomplete sleep history! Please clock it out first!"
}
```

| Response Attributes | Type            | Descriptions                                                |
| ------------------- | --------------- | ----------------------------------------------------------- |
| message             | String          | Notice message from the back-end to elaborate the response. |
| data                | Array(DateTime) | Last 10 clocked-in times, ordered by descending created at. |

| Error code | Descriptions                                                                                                           |
| ---------- | ---------------------------------------------------------------------------------------------------------------------- |
| 404        | Not found; User not found!                                                                                             |
| 400        | Bad request; The user has incomplete sleep history, please clock it out first before create another clocked-in record! |

### Sleep Histories - Clock Out API

API for recording the clocked-out time. The initial sleep history that created using clock in API will be updated and the record will have clocked-out time and automatically calculates the duration.

#### Source code

- [link to the controller](https://github.com/shabanzo/good-night/blob/master/app/controllers/api/v1/users/sleep_histories_controller.rb#L19-L30)
- [link to the class service](https://github.com/shabanzo/good-night/blob/master/app/services/sleep_history/clock_out.rb)

```
PATCH /api/v1/users/:user_id/sleep_histories/clock_out
```

| Request Parameters | Type    | Descriptions         |
| ------------------ | ------- | -------------------- |
| user_id            | Integer | The current user ID. |

#### Request parameters example:

```
POST /api/v1/users/1/sleep_histories/clock_in
```

#### Success response example (status: 200):

```json
{
  "message": "Congratulations, your clock-out has been recorded successfully!"
}
```

#### Failed response example (status: 400):

```json
{
  "message": "Bad request; You do not have clocked in sleep history! Please clock in first!"
}
```

| Response Attributes | Type   | Descriptions                                                |
| ------------------- | ------ | ----------------------------------------------------------- |
| message             | String | Notice message from the back-end to elaborate the response. |

| Error code | Descriptions                                                                        |
| ---------- | ----------------------------------------------------------------------------------- |
| 404        | Not found; User not found!                                                          |
| 400        | Bad request; The user doesn't have clocked-in sleep history, please clock in first! |

### Users API

API for returning all users to support Follow and Unfollow API.

#### Source code

- [link to the controller](https://github.com/shabanzo/good-night/blob/master/app/controllers/api/v1/users_controller.rb#L5-L7)

```
GET /api/v1/users
```

| Request Parameters | Type    | Descriptions                   |
| ------------------ | ------- | ------------------------------ |
| page               | Integer | The current page.              |
| per_page           | Integer | How many row of data per page. |

#### Request parameters example:

```
GET /api/v1/users/1/users?page=1&per_page=10
```

#### Success response (status: 200):

```json
[
  {
    "id": 1,
    "name": "Syaban"
  }
]
```

| Response Attributes | Type    | Descriptions |
| ------------------- | ------- | ------------ |
| id                  | Integer | User ID      |
| name                | String  | User name.   |

### Relationships - Follow API

API for following the user. The relationship record will be created within this API.

#### Source code

- [link to the controller](https://github.com/shabanzo/good-night/blob/master/app/controllers/api/v1/users/relationships_controller.rb#L5-L15)
- [link to the class service](https://github.com/shabanzo/good-night/blob/master/app/services/relationship/follow.rb)

```
POST /api/v1/users/:user_id/relationships/follow
```

| Request Parameters | Type    | Descriptions                       |
| ------------------ | ------- | ---------------------------------- |
| user_id            | Integer | The current user ID.               |
| target_user_id     | Integer | The target user id to be followed. |

#### Request parameters example:

```
POST /api/v1/users/1/relationships/follow

{
  target_user_id: 2
}
```

#### Success response example (status: 200):

```json
{
  "message": "You are now following this user!"
}
```

#### Failed response example (status: 400):

```json
{
  "message": "Bad request; You are already following the target user!"
}
```

| Response Attributes | Type   | Descriptions                                                |
| ------------------- | ------ | ----------------------------------------------------------- |
| message             | String | Notice message from the back-end to elaborate the response. |

| Error codes | Descriptions                                                                                         |
| ----------- | ---------------------------------------------------------------------------------------------------- |
| 404         | Not found; Whether The current user or the targeted user is not found! Or they're following themself |
| 400         | Bad request; You are already following the target user!                                              |

### Relationships - Unfollow API

API for unfollowing the user. The relationship record will be deleted within this API.

#### Source code

- [link to the controller](https://github.com/shabanzo/good-night/blob/master/app/controllers/api/v1/users/relationships_controller.rb#L18-L28)
- [link to the class service](https://github.com/shabanzo/good-night/blob/master/app/services/relationship/unfollow.rb)

```
DELETE /api/v1/users/:user_id/relationships/unfollow
```

| Request Parameters | Type    | Descriptions                       |
| ------------------ | ------- | ---------------------------------- |
| user_id            | Integer | The current user ID.               |
| target_user_id     | Integer | The target user id to be followed. |

#### Request parameters example:

```
DELETE /api/v1/users/1/relationships/unfollow

{
  target_user_id: 2
}
```

#### Success response (status: 200):

```json
{
  "message": "You are now unfollow this user!"
}
```

#### Failed response (status: 400):

```json
{
  "message": "Bad request; You've already unfollowed the target user!"
}
```

| Response Attributes | Type   | Descriptions                                                |
| ------------------- | ------ | ----------------------------------------------------------- |
| message             | String | Notice message from the back-end to elaborate the response. |

| Error codes | Descriptions                                                           |
| ----------- | ---------------------------------------------------------------------- |
| 404         | Not found; Whether The current user or the targeted user is not found! |
| 400         | Bad request; You are already following the target user!                |

### Sleep Histories - Following API

API for returning all following's sleep histories.

#### Source code

- [link to the controller](https://github.com/shabanzo/good-night/blob/master/app/controllers/api/v1/users/sleep_histories_controller.rb#L33-L35)

```
GET /api/v1/users/:user_id/sleep_histories/following
```

| Request Parameters | Type    | Descriptions                   |
| ------------------ | ------- | ------------------------------ |
| page               | Integer | The current page.              |
| per_page           | Integer | How many row of data per page. |

#### Request parameters example:

```
GET /api/v1/users/1/sleep_histories/following?page=1&per_page=10
```

#### Success response (status: 200):

```json
[
  {
    "id": 1,
    "user_name": "Syaban",
    "clock_in_time": "2024-12-08T23:00:00.000Z",
    "clock_out_time": "2024-12-09T08:00:00.000Z",
    "duration_minutes": 540
  }
]
```

| Response Attributes | Type     | Descriptions                        |
| ------------------- | -------- | ----------------------------------- |
| id                  | Integer  | Sleep history ID.                   |
| user_name           | String   | How many row of data per page.      |
| clock_in_time       | DateTime | The time when the user clocked-in.  |
| clock_out_time      | DateTime | The time when the user clocked-out. |
| duration_minutes    | Integer  | Duration of sleep in minutes.       |
