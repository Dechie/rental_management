import 'property_model.dart';

List<PropertyModel> propertyRentList = [
  // House Type
  PropertyModel(
    id: 'house1',
    propertyType: PropertyType.house,
    images: [
      'https://www.homestratosphere.com/wp-content/uploads/2018/07/green-house-example2018-07-09-at-5.03.11-PM-31-870x579.jpg'
          'house1_img2.jpg',
    ],
    price: '250.0',
    region: 'Region A',
    city: 'City X',
    subcity: 'Subcity Y',
    description: 'Beautiful house with a nice view.',
    contact: '123-456-7890',
    updatedAt: '2024-06-01',
    details: {
      'bedrooms': 3,
      'bathrooms': 2,
      'balconies': 2,
    },
  ),
  // Car Type
  PropertyModel(
    id: 'car1',
    propertyType: PropertyType.car,
    images: ['car1_img1.jpg', 'car1_img2.jpg'],
    price: '20,000',
    region: 'Region B',
    city: 'Addis Ababa',
    subcity: 'Subcity Z',
    description: 'Sleek car with modern features.',
    contact: '234-567-8901',
    updatedAt: '2024-06-02',
    details: {
      'model': 'Model S',
      'mileage': '15000',
      'fuel_capacity': '75L',
    },
  ),
  // Garment Type
  PropertyModel(
    id: 'garment1',
    propertyType: PropertyType.garment,
    images: [
      'garment1_img1.jpg',
      'garment1_img2.jpg',
    ],
    price: '50',
    region: 'Region C',
    city: 'Addis Ababa',
    subcity: 'Subcity A',
    description: 'Stylish garment made of high-quality fabric.',
    contact: '345-678-9012',
    updatedAt: '2024-06-03',
    details: {
      'fabric_type': 'Cotton',
      'male_or_female': 'Male',
      'size': 'L',
    },
  ),
  PropertyModel(
    id: 'house1',
    propertyType: PropertyType.house,
    images: ['house1_img1.jpg', 'house1_img2.jpg'],
    price: '250,000',
    region: 'Region A',
    city: 'City X',
    subcity: 'Subcity Y',
    description: 'Beautiful house with a nice view.',
    contact: '123-456-7890',
    updatedAt: '2024-06-01',
    details: {
      'bedrooms': 3,
      'bathrooms': 2,
      'balconies': 2,
    },
  ),
  PropertyModel(
    id: 'house2',
    propertyType: PropertyType.house,
    images: ['house2_img1.jpg', 'house2_img2.jpg'],
    price: '300,000',
    region: 'Region B',
    city: 'City Y',
    subcity: 'Subcity Z',
    description: 'Spacious house with a big garden.',
    contact: '234-567-8901',
    updatedAt: '2024-06-02',
    details: {
      'bedrooms': 4,
      'bathrooms': 3,
      'balconies': 1,
    },
  ),
  PropertyModel(
    id: 'house3',
    propertyType: PropertyType.house,
    images: ['house3_img1.jpg', 'house3_img2.jpg'],
    price: '350,000',
    region: 'Region C',
    city: 'City Z',
    subcity: 'Subcity A',
    description: 'Modern house with a swimming pool.',
    contact: '345-678-9012',
    updatedAt: '2024-06-03',
    details: {
      'bedrooms': 5,
      'bathrooms': 4,
      'balconies': 3,
    },
  ),
  // Car Type
  PropertyModel(
    id: 'car1',
    propertyType: PropertyType.car,
    images: ['car1_img1.jpg', 'car1_img2.jpg'],
    price: '20,000',
    region: 'Region A',
    city: 'City X',
    subcity: 'Subcity Y',
    description: 'Sleek car with modern features.',
    contact: '123-456-7890',
    updatedAt: '2024-06-01',
    details: {
      'model': 'Model S',
      'mileage': '15000',
      'fuel_capacity': '75L',
    },
  ),
  PropertyModel(
    id: 'car2',
    propertyType: PropertyType.car,
    images: ['car2_img1.jpg', 'car2_img2.jpg'],
    price: '25,000',
    region: 'Region B',
    city: 'City Y',
    subcity: 'Subcity Z',
    description: 'Luxury car with premium interiors.',
    contact: '234-567-8901',
    updatedAt: '2024-06-02',
    details: {
      'model': 'Model X',
      'mileage': '10000',
      'fuel_capacity': '80L',
    },
  ),
  PropertyModel(
    id: 'car3',
    propertyType: PropertyType.car,
    images: ['car3_img1.jpg', 'car3_img2.jpg'],
    price: '30,000',
    region: 'Region C',
    city: 'City Z',
    subcity: 'Subcity A',
    description: 'Electric car with advanced technology.',
    contact: '345-678-9012',
    updatedAt: '2024-06-03',
    details: {
      'model': 'Model 3',
      'mileage': '5000',
      'fuel_capacity': '100L',
    },
  ),
  // Garment Type
  PropertyModel(
    id: 'garment1',
    propertyType: PropertyType.garment,
    images: ['garment1_img1.jpg', 'garment1_img2.jpg'],
    price: '50',
    region: 'Region A',
    city: 'City X',
    subcity: 'Subcity Y',
    description: 'Stylish garment made of high-quality fabric.',
    contact: '123-456-7890',
    updatedAt: '2024-06-01',
    details: {
      'fabric_type': 'Cotton',
      'male_or_female': 'Unisex',
      'size': 'L',
    },
  ),
  PropertyModel(
    id: 'garment2',
    propertyType: PropertyType.garment,
    images: ['garment2_img1.jpg', 'garment2_img2.jpg'],
    price: '75',
    region: 'Region B',
    city: 'City Y',
    subcity: 'Subcity Z',
    description: 'Elegant dress suitable for formal occasions.',
    contact: '234-567-8901',
    updatedAt: '2024-06-02',
    details: {
      'fabric_type': 'Silk',
      'male_or_female': 'Female',
      'size': 'M',
    },
  ),
  PropertyModel(
    id: 'garment3',
    propertyType: PropertyType.garment,
    images: ['garment3_img1.jpg', 'garment3_img2.jpg'],
    price: '100',
    region: 'Region C',
    city: 'City Z',
    subcity: 'Subcity A',
    description: 'Casual wear made of breathable fabric.',
    contact: '345-678-9012',
    updatedAt: '2024-06-03',
    details: {
      'fabric_type': 'Linen',
      'male_or_female': 'Male',
      'size': 'XL',
    },
  ),
];
