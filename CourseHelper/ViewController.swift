//
//  ViewController.swift
//  CourseHelper
//
//  Created by Eyoab Asrat on 6/12/21.
//

import UIKit

class ViewController: UIViewController,UITableViewDataSource,UITableViewDelegate, UISearchBarDelegate {
  
  
   
    @IBOutlet weak var searchBar: UITableView!
    
   
    @IBOutlet weak var courseTableView: UITableView?
    
    
    var classesOG = [String]()
    var filteredData:[String]!
    
    
    override func viewDidLoad() {
        
        courseTableView?.dataSource = self
        courseTableView?.delegate = self
       
        
        fetchClassData { [weak self] (classes2) in
            for classes in classes2 {
                self?.classesOG.append(classes.course_id)
             
                //print(self.classesOG)
            }
            
            self?.courseTableView?.reloadData()
        }
       
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String){
        print(searchText)
    }
    
    
    
    
    
    func fetchClassData(completionHandler: @escaping ([classes]) -> Void){
        /*completionHandler allows access to a certain value within a block of code.
         *Also allows us to retrieve all the collected information even if we begin to have a delay.
         *Runs everything after it is retireved, not like a return statement where you retrieve something than immediately return it.
         *Without it, it would just return nil.
        */

        let url = URL(string: "https://api.umd.io/v1/courses/list")!
        //Exclamation point unwraps the website - tells the code the website exsists

        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            /*The task allows us to fetch data(Specefically the URLSession).
             *the 'in' is where we tell what to do with the information we get from the internet
             *if we obtain data we store into that data variable
             *if we get an error we store into that error variable
             if we get a response we store that into the response variable (i.e - Error code)
            */

            guard let data = data else{
                return
                /*

                 *Line 50 ~If I can create a variable called data from the original data, we are going to store it and then unwrap it.
                 *Otherwise we will return whatever eroor message we have
                 */
            }
            do{
                //Think of try catch statement
                let classData = try JSONDecoder().decode([classes].self, from: data)
                //does the unwrapping of the info
                completionHandler(classData)

            }catch{
                let error = error
                print(error.localizedDescription)

                //catches the error if it there is one.
            }

        }.resume()

        
}

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  classesOG.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ClassesTableViewCell", for: indexPath) as! ClassesTableViewCell
        
        let classes = classesOG[indexPath.row]
        cell.courseName.text = classes
        return cell
    }
    
    
  
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String){

        filteredData = []

        if searchText == ""{
            filteredData = classesOG
        }else{

        for classes in classesOG {
            if classes.lowercased().contains(searchText.lowercased()){

                filteredData.append(classes)
           }
        }
    }
        self.courseTableView?.reloadData()
  }
    
    
}



class FirstViewController: UIViewController{
    
    
    @IBOutlet weak var btnClickOnMe: UIButton!
    
    override func viewDidLoad() {
            super.viewDidLoad()
        btnClickOnMe.addTarget(self, action: #selector(tapOnButton), for: .touchUpInside)
        
    }
    
    @objc func tapOnButton(){
        let story = UIStoryboard(name: "Main", bundle: nil)
        let controller = story.instantiateViewController(identifier: "ViewController") as! ViewController
        self.present(controller, animated: true, completion: nil)
    }
}



