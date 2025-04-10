

import UIKit
import Kingfisher

class PokemonCell: UITableViewCell {

    static let identifier = "PokemonCell"

    private let pokemonImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        contentView.addSubview(pokemonImageView)
        contentView.addSubview(nameLabel)

        NSLayoutConstraint.activate([
            pokemonImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            pokemonImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            pokemonImageView.widthAnchor.constraint(equalToConstant: 50),
            pokemonImageView.heightAnchor.constraint(equalToConstant: 50),

            nameLabel.leadingAnchor.constraint(equalTo: pokemonImageView.trailingAnchor, constant: 10),
            nameLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10)
        ])
    }

    func configure(with pokemon: Pokemon, detail: PokemonDetail?) {
        nameLabel.text = pokemon.name.capitalized

        if let imageUrl = detail?.sprites.frontDefault, let url = URL(string: imageUrl) {
            pokemonImageView.kf.setImage(with: url)
        } else {
            pokemonImageView.image = nil
        }
    }
}
