import UIKit
import Kingfisher

class DetailViewController: UIViewController {


    @IBOutlet weak var pokemonImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var weightLabel: UILabel!
    @IBOutlet weak var heightLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!

    var pokemonDetail: PokemonDetail?

    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
    }

    private func updateUI() {
        guard let pokemonDetail = pokemonDetail else { return }

        if let imageUrl = pokemonDetail.sprites.frontDefault, let url = URL(string: imageUrl) {
            pokemonImageView.kf.setImage(with: url)
        }

        nameLabel.text = pokemonDetail.name.capitalized
        weightLabel.text = "Weight: \(pokemonDetail.weight) kg"
        heightLabel.text = "Height: \(pokemonDetail.height) cm"
        typeLabel.text = "Type: \(pokemonDetail.types.map { $0.type.name.capitalized }.joined(separator: ", "))"
    }
}
