# Fetch Meals

A native iOS app that allow users to browse meals from various categories using the [themealdb.com](https://themealdb.com/api.php) API.

<img src="https://github.com/hauntarl/hauntarl/blob/master/desserts/DessertsAppIcon.png">

### Project
- Developed by: [Sameer Mungole](https://www.linkedin.com/in/sameer-mungole/)
- XCode Version **15.4 (15F31d)**
- Minimum deployment: **iOS 17.5**
- Tested on **iPhone 15 Pro** (Simulator) and **iPhone 15** (Physical device)
- Supports **portrait-up** device orientation

### Features

- User can tap on a meal from the list to navigate to a view displaying details for the selected meal.
- User can click on the `Settings` icon in the top-right corner to perform the following:
    - Sort by `Name` or `Id` of the meal.
    - Arrange meals in `Ascending` or `Descending` order.
    - Change the meal category from the list of options.
- User can filter the meals by entering query in the search bar.
- User can pull to refresh.
- User can retry fetching data when an error occurs in the app.

> Note: Some features are beyond the scope of requirement, but they have been implemented to showcase **scalability** of my submission.

### Architecture and Design

- Utilized the [Model-view-viewmodel (MVVM)](https://en.wikipedia.org/wiki/Model%E2%80%93view%E2%80%93viewmodel) architecture to achieve separation of concern.
- Followed `SOLID` design principles to make a application more scalable and maintainable.
- Followed the [Test-driven development (TDD)](https://en.wikipedia.org/wiki/Test-driven_development) paradigm to ensure robustness in the app.
- Used Constructor and Environment based [Dependency Injection](https://medium.com/@batrakov.vitaly/di-in-swiftui-9f929b50ab5c) to improve mocking and testability.

### Models

- Implemented a custom decoding strategy to perform corrupt data and null safety checks while parsing.
- Made the parsing scalable by utilizing `DynamicKeys` for **ingredients** and **measures**.
- Applied various transformations on the response data to convert them into meaningful Swift objects.
- Added samples for each model, utilized by previews and unit tests to mock network response.

### Network

- Followed the *Liskov Substitution Principle* in conjunction with Protocol-based mocking for app's main content, previews, and unit tests.
- Designed a scalable solution for **Network**, capable of handling any type of request (not limited to `HTTP-GET`).
- Wrote unit tests with **100%** code coverage.

> Note: I've added an API call to fetch meal categories, which is beyond the scope of requirements.
> This is done in order to highlight the scalable nature of my solution.
 
### Views

- Created a complete mock environment (including navigation) using `Previews` for each view, this removes unnecessary network calls while designing/updating the UI.
- Used the **Router** pattern to handle the app's navigation.
- Made sure that *view models* strictly follow the *Single Responsibility Principle*, i.e, they are only responsible for handling the view's data.
- Have added error flow to improve the user experience.
- Kept it simple and clutter-free, followed the Apple's **Human-Interface Guidelines**.
- Have added basic animations and transitions to improve the overall user experience.
- Wrote unit tests for view models with **100%** code coverage.

> Note: I've added a small optimization while fetching thumbnails in the `MealsView`.
> I appended `/preview` path to the retrieved url, [themealdb.com](https://themealdb.com/api.php) returns a 
> `200x200` image instead of `600x600`.
>
> This might result in some inconsistencies as the thumbnail might not load in the `MealsView` but will load in the
> `MealDetailsView`. It probably happens because the API doesn't have a preview image for all the meals.

### Assets

- [App icon](https://www.pexels.com/photo/close-up-photo-of-dessert-on-top-of-the-jar-2638026/): Photo by *Anna Tukhfatullina* Food Photographer/Stylist.
- Accent color `#FBA91A`: Orangish-yellow from [fetch.com](https://fetch.com/)'s logo

> Disclosure:
>
> I applied to Fetch a few months back and received a take-home assessment, but I didn't proceed further
> in the interview process due to missing some key requirements in my submission.
>
> I found the feedback extremely valuable and have since improved my knowledge of the SwiftUI framework
> and applied it diligently in my future projects.
>
> The feedback for my previous submission: [github.com/hauntarl/desserts](https://github.com/hauntarl/desserts)
> 
> - Why focus on the UI when you won't be graded on it?
> - How can you make decoding DessertDetail more scalable when the backend changes?
> - How can you improve the NetworkManager? Should the view model be responsible for building API URLs?
>
> I have used this opportunity improve upon all the shortcomings from my previous submission.
>
> I'm eagerly looking forward to your review, hoping to "make fetch happen" (ref. Mean Girls)
