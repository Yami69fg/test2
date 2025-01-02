import UIKit
import SnapKit

class LoadAirViewController: UIViewController {

    private let backgroundImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "BGAirport"))
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let loadingLabel: UILabel = {
        let label = UILabel()
        let strokeColor = UIColor(red: 104/255, green: 47/255, blue: 39/255, alpha: 1.0)
        label.attributedText = NSAttributedString(string: "Loading.", attributes: [
            .font: UIFont(name: "Oswald-Bold", size: 24) ?? UIFont.boldSystemFont(ofSize: 24),
            .foregroundColor: UIColor.white,
            .strokeColor: strokeColor,
            .strokeWidth: -1.0
        ])
        label.textAlignment = .center
        label.shadowColor = UIColor(red: 133/255, green: 56/255, blue: 0/255, alpha: 1.0)
        label.shadowOffset = CGSize(width: 0, height: 1)
        return label
    }()
    
    private var loadingTimer: Timer?
    private var loadingDots = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        startLoadingAnimation()
        navigateToNextControllerAfterDelay()
    }
    
    private func setupUI() {
        view.addSubview(backgroundImageView)
        view.addSubview(loadingLabel)
        
        backgroundImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        loadingLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().inset(30)
        }
    }
    
    private func startLoadingAnimation() {
        loadingTimer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            self.loadingDots = (self.loadingDots + 1) % 4
            self.loadingLabel.text = "Loading" + String(repeating: ".", count: self.loadingDots)
        }
    }
    
    private func navigateToNextControllerAfterDelay() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) { [weak self] in
            self?.loadingTimer?.invalidate()
            self?.loadingTimer = nil
            if UserDefaults.standard.bool(forKey: "hasLaunchedFirstTime") {
                let nextViewController = AirportMainController()
                nextViewController.modalPresentationStyle = .fullScreen
                self?.present(nextViewController, animated: true, completion: nil)
            } else {
                UserDefaults.standard.set(true, forKey: "hasLaunchedFirstTime")
                let nextViewController = AirportInfoController()
                nextViewController.modalPresentationStyle = .fullScreen
                self?.present(nextViewController, animated: true, completion: nil)
            }
        }
    }
}
