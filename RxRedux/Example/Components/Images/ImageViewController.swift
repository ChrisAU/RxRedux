import UIKit
import SnapKit
import Action

enum ImageViewAccessibility: String {
    case scrollView
    case contentView
    case imageView
    case titleLabel
    case tagsLabel
    case authorLabel
    case linkButton
}

class ImageViewController: UIViewController {
    fileprivate lazy var scrollView = UIScrollView(ImageViewAccessibility.scrollView)
    fileprivate lazy var contentView = UIView(ImageViewAccessibility.contentView)
    fileprivate lazy var imageView = UIImageView(ImageViewAccessibility.imageView)
    fileprivate lazy var titleLabel = UILabel(ImageViewAccessibility.titleLabel)
    fileprivate lazy var tagsLabel = UILabel(ImageViewAccessibility.tagsLabel)
    fileprivate lazy var authorLabel = UILabel(ImageViewAccessibility.authorLabel)
    fileprivate lazy var linkButton = UIButton(ImageViewAccessibility.linkButton)
    
    var presenter: ImagePresenter<ImageViewController>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        render()
        presenter?.attachView(self)
    }
    
    deinit {
        presenter?.detachView()
    }
    
    func render() {
        edgesForExtendedLayout = []
        view.backgroundColor = .white
        
        view.addSubview(scrollView) { make in
            make.edges.equalToSuperview()
        }
        
        scrollView.addSubview(contentView) { make in
            make.top.bottom.equalToSuperview()
            make.width.equalTo(view.snp.width)
        }
        
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFit
        contentView.addSubview(imageView) { make in
            make.leading.trailing.top.equalToSuperview()
            make.height.equalTo(0)
        }
        
        titleLabel.numberOfLines = 0
        contentView.addSubview(titleLabel) { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.top.equalTo(imageView.snp.bottom).offset(20)
        }
        
        authorLabel.numberOfLines = 2
        contentView.addSubview(authorLabel) { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
        }
        
        tagsLabel.numberOfLines = 0
        contentView.addSubview(tagsLabel) { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.top.equalTo(authorLabel.snp.bottom).offset(20)
        }
        
        contentView.addSubview(linkButton) { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.top.equalTo(tagsLabel.snp.bottom).offset(20)
            make.height.equalTo(44)
            make.bottom.equalToSuperview().inset(20)
        }
    }
}

extension ImageViewController: ImageView {
    func setImageInfo(_ imageInfo: ImageInfo) {
        ImageApi.downloadImage(at: imageInfo.imageUrl) { [weak self] (result) in
            if case .success(let image) = result {
                guard let `self` = self else {
                    return
                }
                let screenWidth = UIScreen.main.bounds.width
                let adjustedHeight = screenWidth * (image.size.height / image.size.width)
                self.imageView.image = image
                self.imageView.snp.updateConstraints ({ (make) in
                    make.height.equalTo(adjustedHeight)
                })
            }
        }
        
        titleLabel.text = imageInfo.title
        authorLabel.text = imageInfo.author
        tagsLabel.text = imageInfo.tags.joined(separator: ", ")
    }
    
    func setLinkAction(_ action: CocoaAction) {
        linkButton.rx.action = action
    }
    
    func setLinkTitle(_ title: String) {
        linkButton.setTitle(title, for: .normal)
    }
}

