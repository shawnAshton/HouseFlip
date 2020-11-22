//
//  OfferEstimatorViewController.swift
//  HouseFlip
//
//  Created by Shawn Ashton on 11/20/20.
//

import UIKit

class OfferEstimatorViewController: UIViewController {
    @IBOutlet weak var arvVal: UITextField!
    @IBOutlet weak var estimatedRepairCostVal: UITextField!
    @IBOutlet weak var percentOne: UILabel!
    @IBOutlet weak var percentTwo: UILabel!
    @IBOutlet weak var slider1: UISlider!
    @IBOutlet weak var slider2: UISlider!
    @IBOutlet weak var closingCosts: UILabel!
    @IBOutlet weak var profitMargin: UILabel!
    @IBOutlet weak var suggestedOffer: UITextView!
    var arv:Double = 0.0
    var estimatedRepairCosts:Double = 0.0
    var slider1Val:Double = 0.1
    var slider2Val:Double = 0.1
    
    @IBAction func slider1DidSlide(_ sender: UISlider) {
        let percent:Float = Float(Int((sender.value)*10)) / 10
        closingCosts.text = String(format: "Closing Costs(%.2f * \(slider1Val)) = %.2f" ,arv,(arv * slider1Val))
        percentOne.text = "\(percent)%"
        calculateSuggestedOffer()
    }
    
    @IBAction func slider2DidSlide(_ sender: UISlider) {
        let percent:Float = Float(Int((sender.value)*10)) / 10
        percentTwo.text = "\(percent)%"
        profitMargin.text = String(format: "Profit Margin(%.2f * \(slider2Val)) = %.2f" ,arv, (arv * slider2Val))
        calculateSuggestedOffer()
    }
    
    @IBAction func arvHasChanged(_ sender: UITextField) {
        arv = Double(arvVal.text!) ?? 0.0
        closingCosts.text = String(format: "Closing Costs(%.2f * \(slider1Val)) = %.2f" ,arv,(arv * slider1Val))
        profitMargin.text = String(format: "Profit Margin(%.2f * \(slider2Val)) = %.2f" ,arv, (arv * slider2Val))
        calculateSuggestedOffer()
        
    }
    @IBAction func repairCostsHaveChanged(_ sender: UITextField) {
        estimatedRepairCosts = Double(estimatedRepairCostVal.text!) ?? 0.0
        calculateSuggestedOffer()
        
    }
    
    func calculateSuggestedOffer(){
        //arv = Double(arvVal.text!) ?? 0.0
        estimatedRepairCosts = Double(estimatedRepairCostVal.text!) ?? 0.0
        slider1Val = Double(Int((slider1.value)*10)) / 1000
        slider2Val = Double(Int((slider2.value)*10)) / 1000
        suggestedOffer.text = String(format: "$%.2f(After Repair Value) \n- $%.2f(Estimated Repair Costs) \n- $%.2f(Closing Costs)\n- $%.2f(Profit Margin)\n\nSuggested Offer = $%.2f", arv,estimatedRepairCosts,arv*slider1Val,arv*slider2Val,
                                     arv-estimatedRepairCosts-(arv*slider1Val)-(arv*slider2Val))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        percentOne.text = "10.0%"
        percentTwo.text = "10.0%"
        slider1.value = 10
        slider2.value = 10
        closingCosts.text = String(format: "Closing Costs(%.2f * \(slider1Val)) = %.2f" ,arv, slider1Val,(arv * slider1Val))
        profitMargin.text = String(format: "Profit Margin(%.2f * \(slider2Val)) = %.2f" ,arv, (arv * slider2Val))
        calculateSuggestedOffer()

        // Do any additional setup after loading the view.
    }
    


}
