import UIKit
import Alamofire
import Kingfisher

class ViewController: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var pokemonTextField: UITextField!
    @IBOutlet weak var tableView: UITableView!

    var allPokemon: [Pokemon] = []
    var filteredPokemon: [Pokemon] = []
    var pokemonDetails: [PokemonDetail] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        fetchPokemonList()
        hideKeyboardWhenTappedAround()
    }

    private func setupUI() {
        searchBar.delegate = self
        pokemonTextField.delegate = self
        tableView.dataSource = self
        tableView.delegate = self
        tableView.isHidden = true
        pokemonTextField.addTarget(self, action: #selector(textFieldEditingChanged), for: .editingChanged)
        tableView.register(PokemonCell.self, forCellReuseIdentifier: "PokemonCell")
    }

    private func fetchPokemonList() {
        PokemonManager.shared.fetchPokemonList { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let pokemonList):
                    self?.allPokemon = pokemonList
                    self?.filteredPokemon = pokemonList
                    self?.fetchPokemonDetails()
                case .failure(let error):
                    self?.showError(error)
                }
            }
        }
    }

    private func fetchPokemonDetails() {
        for pokemon in allPokemon {
            PokemonManager.shared.fetchPokemonDetail(from: pokemon.url) { [weak self] result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let pokemonDetail):
                        self?.pokemonDetails.append(pokemonDetail)
                        if self?.pokemonDetails.count == self?.allPokemon.count {
                            self?.tableView.reloadData()
                        }
                    case .failure(let error):
                        self?.showError(error)
                    }
                }
            }
        }
    }

    private func showError(_ error: Error) {
        let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}

extension ViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            filteredPokemon = allPokemon
        } else {
            filteredPokemon = allPokemon.filter { pokemon in
                let pokemonDetail = pokemonDetails.first { $0.name == pokemon.name }
                let nameMatches = pokemon.name.lowercased().contains(searchText.lowercased())
                let typeMatches = pokemonDetail?.types.contains { $0.type.name.lowercased().contains(searchText.lowercased()) } ?? false
                return nameMatches || typeMatches
            }
        }
        tableView.reloadData()
        tableView.isHidden = filteredPokemon.isEmpty
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredPokemon.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "PokemonCell", for: indexPath) as? PokemonCell else {
            return UITableViewCell()
        }
        let pokemon = filteredPokemon[indexPath.row]
        let pokemonDetail = pokemonDetails.first { $0.name == pokemon.name }
        cell.configure(with: pokemon, detail: pokemonDetail)
        return cell
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedPokemon = filteredPokemon[indexPath.row]
        let selectedPokemonDetail = pokemonDetails.first { $0.name == selectedPokemon.name }

        // Navegar a DetailViewController
        if let detailViewController = storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as? DetailViewController {
            detailViewController.pokemonDetail = selectedPokemonDetail
            navigationController?.pushViewController(detailViewController, animated: true)
        } else {
            print("Error: No se pudo encontrar el DetailViewController en el Storyboard.")
        }
    }
}

extension ViewController: UITextFieldDelegate {
    @objc func textFieldEditingChanged(_ textField: UITextField) {
        tableView.isHidden = false
        searchBar(searchBar, textDidChange: textField.text ?? "")
    }

    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        tableView.isHidden = false
        return true
    }
}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
