import UIKit
import SnapKit

class AirportSettingViewController: UIViewController {

    private let backgroundImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "BGAirport"))
        imageView.contentMode = .scaleToFill
        imageView.clipsToBounds = true
        return imageView
    }()

    private let sideImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "BGSetting"))
        imageView.contentMode = .scaleToFill
        imageView.isUserInteractionEnabled = true
        return imageView
    }()

    private let topLeftButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "Back"), for: .normal)
        button.clipsToBounds = true
        return button
    }()

    private let chinaLabel: UILabel = {
        let label = UILabel()
        let strokeColor = UIColor(red: 104/255, green: 47/255, blue: 39/255, alpha: 1.0)
        label.attributedText = NSAttributedString(string: "SETTINGS", attributes: [
            .font: UIFont(name: "Oswald-Bold", size: 52) ?? UIFont.boldSystemFont(ofSize: 52),
            .foregroundColor: UIColor.white,
            .strokeColor: strokeColor,
            .strokeWidth: -1.0
        ])
        label.textAlignment = .center
        label.shadowColor = UIColor(red: 133/255, green: 56/255, blue: 0/255, alpha: 1.0)
        label.shadowOffset = CGSize(width: 0, height: 1)
        return label
    }()

    private let labelsText = ["Music", "Sound", "Vibro"]
    private var isMusic = UserDefaults.standard.bool(forKey: "isMusicOn")
    private var isSound = UserDefaults.standard.bool(forKey: "isSoundOn")
    private var isVibro = UserDefaults.standard.bool(forKey: "isVibroOn")

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    private func setupUI() {
        view.addSubview(backgroundImageView)
        view.addSubview(sideImageView)
        view.addSubview(topLeftButton)
        view.addSubview(chinaLabel)

        backgroundImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        topLeftButton.snp.makeConstraints { make in
            make.top.equalTo(view.snp.top).offset(30)
            make.left.equalTo(view.snp.left).offset(30)
            make.width.equalTo(50)
            make.height.equalTo(50)
        }

        sideImageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.6)
            make.height.equalToSuperview().multipliedBy(0.4)
        }

        chinaLabel.snp.makeConstraints { make in
            make.bottom.equalTo(sideImageView.snp.top)
            make.centerX.equalToSuperview()
        }

        topLeftButton.addTarget(self, action: #selector(didTapBack), for: .touchUpInside)
        addButtonSound(button: topLeftButton)
        createLabels()
        createBottomStack() 
    }

    private func createLabels() {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 15
        stackView.alignment = .center
        stackView.distribution = .equalSpacing

        for text in labelsText {
            let button = UIButton(type: .custom)
            let imageName: String
            switch text {
            case "Music":
                imageName = isMusic ? "ON" : "OFF"
            case "Sound":
                imageName = isSound ? "ON" : "OFF"
            case "Vibro":
                imageName = isVibro ? "ON" : "OFF"
            default:
                imageName = "OFF"
            }
            button.setImage(UIImage(named: imageName), for: .normal)
            button.clipsToBounds = true
            button.tag = labelsText.firstIndex(of: text) ?? 0
            button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
            addButtonSound(button: button)

            let label = UILabel()
            label.text = text
            label.textColor = .white
            label.textAlignment = .center
            label.font = UIFont(name: "Oswald-Bold", size: 20) ?? UIFont.boldSystemFont(ofSize: 20)
            label.shadowColor = UIColor(red: 133/255, green: 56/255, blue: 0/255, alpha: 1.0)
            label.shadowOffset = CGSize(width: 0, height: 1)

            let stackItem = UIStackView()
            stackItem.axis = .horizontal
            stackItem.spacing = 10
            stackItem.addArrangedSubview(button)
            stackItem.addArrangedSubview(label)

            stackView.addArrangedSubview(stackItem)
        }

        sideImageView.addSubview(stackView)

        stackView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.8)
            make.height.equalTo(40)
        }
    }

    private func createBottomStack() {
        let bottomStackView = UIStackView()
        bottomStackView.axis = .horizontal
        bottomStackView.spacing = 30
        bottomStackView.alignment = .center
        bottomStackView.distribution = .equalSpacing

        let buttonTitles = ["Rate", "Privacy", "Share"]

        for title in buttonTitles {
            let button = UIButton(type: .system)
            let label = UILabel()
            let strokeColor = UIColor(red: 104/255, green: 47/255, blue: 39/255, alpha: 1.0)
            label.attributedText = NSAttributedString(string: title, attributes: [
                .font: UIFont(name: "Oswald-Bold", size: 32) ?? UIFont.boldSystemFont(ofSize: 32),
                .foregroundColor: UIColor.white,
                .strokeColor: strokeColor,
                .strokeWidth: -1.0
            ])
            label.textAlignment = .center
            label.shadowColor = UIColor(red: 133/255, green: 56/255, blue: 0/255, alpha: 1.0)
            label.shadowOffset = CGSize(width: 0, height: 1)

            button.addSubview(label)
            button.addTarget(self, action: #selector(bottomButtonTapped(_:)), for: .touchUpInside)
            bottomStackView.addArrangedSubview(button)

            label.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
        }

        sideImageView.addSubview(bottomStackView)

        bottomStackView.snp.makeConstraints { make in
            make.bottom.equalTo(sideImageView.snp.bottom).offset(-20)
            make.centerX.equalToSuperview()
            make.width.equalTo(sideImageView.snp.width).multipliedBy(0.8)
            make.height.equalTo(40)
        }
    }

    @objc private func bottomButtonTapped(_ sender: UIButton) {
        if let label = sender.subviews.compactMap({ $0 as? UILabel }).first {
            let buttonText = label.text ?? ""
            openLink(for: buttonText)
        }
    }

    private func openLink(for action: String) {
        var urlString: String?

        switch action {
        case "Rate":
            urlString = "https://apps.apple.com/app/idYOUR_APP_ID"
        case "Privacy":
            urlString = "https://www.yourwebsite.com/privacy"
        case "Share":
            urlString = "https://www.yourwebsite.com/share"
        default:
            return
        }

        if let urlString = urlString, let url = URL(string: urlString) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }

    @objc private func buttonTapped(_ sender: UIButton) {
        switch sender.tag {
        case 0:
            musicAction(sender)
        case 1:
            soundAction(sender)
        case 2:
            vibroAction(sender)
        default:
            break
        }
    }

    private func musicAction(_ sender: UIButton) {
        isMusic.toggle()
        let imageName = isMusic ? "ON" : "OFF"
        UserDefaults.standard.set(isMusic, forKey: "isMusicOn")
        if isMusic {
            Sound.shared.playBackgroundMusic()
        } else {
            Sound.shared.pauseBackgroundMusic()
        }
        sender.setImage(UIImage(named: imageName), for: .normal)
    }

    private func soundAction(_ sender: UIButton) {
        isSound.toggle()
        let imageName = isSound ? "ON" : "OFF"
        UserDefaults.standard.set(isSound, forKey: "isSoundOn")
        sender.setImage(UIImage(named: imageName), for: .normal)
    }

    private func vibroAction(_ sender: UIButton) {
        isVibro.toggle()
        let imageName = isVibro ? "ON" : "OFF"
        UserDefaults.standard.set(isVibro, forKey: "isVibroOn")
        sender.setImage(UIImage(named: imageName), for: .normal)
    }

    @objc private func didTapBack() {
        dismiss(animated: false, completion: nil)
    }
}
